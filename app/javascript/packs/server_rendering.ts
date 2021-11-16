import * as ReactRailsUJS from "react_ujs"
// By default, this pack is loaded for server-side rendering.
// It must expose react_ujs as `ReactRailsUJS` and prepare a require context.
const componentRequireContext = require.context("components", true);

ReactRailsUJS.useContext(componentRequireContext);
