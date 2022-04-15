import { Elm } from "./Main.elm";

// Material Design Imports 
// require("material-components-web-elm/dist/material-components-web-elm.js");
// require("material-components-web-elm/dist/material-components-web-elm.css");

//Lazy
const styles = import.meta.globEager("./Styles/**/*.scss");
// import "./Styles/_index.scss";

const app = Elm.Main.init();
