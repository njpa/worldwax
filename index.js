import { Elm } from './src/Main.elm'

var app = Elm.Main.init({
  node: document.getElementById('app')
});

app.ports.audioPause.subscribe(function({player: player, time: time}) {
	document.getElementById(player).pause();
});

app.ports.audioPlay.subscribe(function({player: player, time: time}) {
	document.getElementById(player).play();
});
