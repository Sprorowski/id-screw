let SessionGame = {
    init(socket) {
      let channel = socket.channel('session_game:lobby', {})
      channel.join()
      this.listenForChats(channel)
      if(this.getPlayer()){
        this.userPlaced(channel); 
        channel.push('players')
      }
    },
    
    listenForChats(channel) {
      document.getElementById('enter-form').addEventListener('submit', (e)=>{
        e.preventDefault()  
        let userName = document.getElementById('user-name').value          
        let player = {id: Math.floor(Math.random() * 10000) , name:userName, ready: false}  
        this.setPlayer(player)  
        channel.push('enter', player)
      })
      channel.on('players', payload => {
        this.userPlaced();
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
    userPlaced(channel){
      let player = this.getPlayer()
      let form = document.getElementById('game-form');
      let playerDiv = document.getElementById('Player');
      let playerID = document.createElement('p');
      form.innerHTML = null;
      playerID.insertAdjacentHTML('beforeend', `${player.name}#<b>${player.id}</b>`)
      playerDiv.innerHTML = (playerID.outerHTML)
      form.appendChild(this.getReadyForm(channel))  
    },
    getPlayer(){
      return JSON.parse(sessionStorage.getItem("player"));
    },
    setPlayer(player){     
      sessionStorage.setItem("player", JSON.stringify(player));
    },
    getForm(form, buttonName, placeholder = null, id = null){
      let betForm = document.createElement('form');
      if(placeholder){
        let betInput = document.createElement('input');
        betInput.placeholder = placeholder
        betInput.id = id
        betInput.type="text" 
        betForm.appendChild(betInput)   
      }    
      betForm.classList.add(form)
      betForm.appendChild(this.createSubmitButton(buttonName)) 
      return betForm
    },
    getReadyForm(channel){
      let form = this.getForm("ready", "Pronto")
      form.addEventListener('submit', e => {
        console.log("Ready")
        e.preventDefault()  
        channel.push('ready', {id:  this.getPlayer().id})
      })
      return form
    }, 
    getBetForm(){
      return getForm("Aposta", "bet", "Apostar")
    },
    getPlayForm(){
      return getForm("Carta", "card", "Jogar")
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
     
    }

  } 
  export default SessionGame