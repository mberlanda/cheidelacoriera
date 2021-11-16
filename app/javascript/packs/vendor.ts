// import 'jquery';
import * as jQuery from 'jquery'

// import 'jquery-ujs/src/rails.js';
import 'bootstrap/dist/js/bootstrap.min.js';
import 'jquery-backstretch/jquery.backstretch.min.js';
import 'waypoints/lib/jquery.waypoints.js';
import 'jquery-timepicker/jquery.timepicker.js';
import 'bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js';
import 'bootstrap-datepicker/dist/locales/bootstrap-datepicker.it.min.js';
import 'multiselect/js/jquery.multi-select.js';
import 'wowjs/dist/wow.min.js';
import 'retinajs/dist/retina.min.js';
// import 'intro.js/intro.js';
import 'regenerator-runtime/runtime'
import 'whatwg-fetch';
import { WOW } from 'wowjs/dist/wow.min.js';

declare global {
    // eslint-disable-next-line @typescript-eslint/no-namespace
    namespace NodeJS {
        interface Global {
            $: JQueryStatic;
            jQuery: JQueryStatic;
            WOW: any;
        }
    }
    interface Window {
        $: JQueryStatic;
        jQuery: JQueryStatic;
        WOW: any;
    }
}

window.$ = window.jQuery = global.$ = global.jQuery = jQuery;
window.WOW = global.WOW = WOW;
