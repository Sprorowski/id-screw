let SessionGame = {
  init(socket) {
    let channel = socket.channel('session_game:lobby', {})
    channel.join()
    this.listenForChats(channel)
    if(this.getPlayer()){
      this.userPlaced(channel); 
      channel.push('players')
      this.setListnetPlayer(channel, this.getPlayer().id) 
    }
  },
  
  listenForChats(channel) {
    document.getElementById('enter-form').addEventListener('submit', (e)=>{
      e.preventDefault()  
      let userName = document.getElementById('user-name').value          
      let player = {id: Math.floor(Math.random() * 10000) , name:userName, ready: false}  
      this.setPlayer(player)  

      channel.push('enter', player)
      channel.on('hand#'+player.id, payload =>{
        this.displayHand(payload.hand, channel)
        this.displayVira(payload.vira)
      })
    })
    document.getElementById('dosomething').addEventListener('click', (e) => {
      e.preventDefault()  
      channel.push('something', {})
    })
    channel.on('players', payload => {
      let player = this.getPlayer();
      payload.player.forEach((p)=>{
          player = p.id === player.id? p : player
      });
      this.setPlayer(player)
      this.userPlaced(channel);
      this.placePlayers(payload.player)
      console.log(payload)
    })

    channel.on('shout', payload => {
        console.log(payload)
      let board = document.querySelector('#borad')

      if(!sessionStorage.getItem("playerId")){
          sessionStorage.setItem("playerId", payload.id);
      }

      let msgBlock = document.createElement('p')
      

      console.log(msgBlock)
      msgBlock.insertAdjacentHTML('beforeend', `${payload.name}: ${payload.id}`)
      board.appendChild(msgBlock)
    })
  },
  
  setListnetPlayer(channel, player_id){
    channel.on('hand#'+player_id, payload =>{
      this.displayBetForm(payload.hand.length)
      this.displayHand(payload.hand, channel)
      this.displayVira(payload.vira)
    })
    channel.on('bet#'+player_id, payload =>{
      this.displayBetForm(payload.hand.length)
    })
  },
  userPlaced(channel){
    let player = this.getPlayer()
    let form = document.getElementById('game-form');
    let playerDiv = document.getElementById('Player');
    let playerID = document.createElement('p');
    form.innerHTML = null;
    playerID.insertAdjacentHTML('beforeend', `${player.name}#<b>${player.id}</b>`)
    playerDiv.innerHTML = (playerID.outerHTML)
    console.log(player.ready)
    if(!player.ready)
      form.appendChild(this.getReadyForm(channel))  
  },
  getPlayer(){
    return JSON.parse(sessionStorage.getItem("player"));
  },
  setPlayer(player){     
    sessionStorage.setItem("player", JSON.stringify(player));
  },
  getForm(form, buttonName, placeholder = null, id = null, size = null ){
    let betForm = document.createElement('form');
    if(placeholder){
      let betInput = document.createElement('input');
      betInput.placeholder = " 0 - "+ size
      betInput.id = id
      betInput.type="text" 
      if(size) {
        betInput.type = "number"
        betInput.max = size        
        betInput.min = 0
      }
      betForm.appendChild(betInput)   
    }       
    betForm.classList.add(form)
    betForm.appendChild(this.createSubmitButton(buttonName)) 
    return betForm
  },
  getReadyForm(channel){
    let form = this.getForm("ready", "Pronto")
    form.addEventListener('submit', e => {
      e.preventDefault()  
      channel.push('ready', {id:  this.getPlayer().id})
    })
    return form
  }, 
  getBetForm(size){
    let form =  this.getForm("Aposta", "bet", "Apostar", null, size)
    form.addEventListener('submit', e => {
      e.preventDefault()  
      console.log("apostar")
    })
    return form
  },
  createSubmitButton(name){
    let button = document.createElement("button")
    button.innerHTML = name
    return button 
  },
  placePlayers(players){
    let playersDiv = document.getElementById('Players');
    let div = document.createElement('div')
    players.forEach(player => {        
      let playerID = document.createElement('p');
      status = player.ready? "Pronto" : "Esperando..."
      playerID.insertAdjacentHTML('beforeend', `${player.name}#<b>${player.id}</b> ${status}`)
      div.appendChild(playerID)
    })
    playersDiv.innerHTML = div.outerHTML
   
  },
  getHandForm(hand){
    let handForm = document.createElement('form');
    hand.forEach(card =>{
      console.log(card)
      let cardButton = document.createElement("input")
      cardButton.value = card
      cardButton.type = "button"
      cardButton.classList.add("handInput")        
      cardButton.disabled = true;
      console.log(cardButton)
      handForm.appendChild(cardButton)
    })
    return handForm

  },
  displayHand(hand, channel){
    let handDiv = document.querySelector('#hand')
    handDiv.innerHTML = this.getHandForm(hand).outerHTML
    
    let handInputs = document.querySelectorAll('.handInput')
    console.log(handInputs)
    handInputs.forEach(el => el.addEventListener('click', e=>{
      console.log(el)
      el.disabled = true;
      channel.push('play', {"card": el.value, "player_id": this.getPlayer().id})
    }))

  },
  displayVira(vira){
    let viraDiv = document.querySelector('#vira')
    console.log(vira)
    viraDiv.innerHTML = vira
  },
  displayBetForm(size){ 
    console.log(size)     
    let form = document.getElementById('game-form');      
    form.innerHTML = null;
    form.appendChild(this.getBetForm(size));
  }

} 
export default SessionGame