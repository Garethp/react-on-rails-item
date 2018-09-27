import React from 'react';
import ReactOnRails from 'react-on-rails';
import Home from "./Home";
import {renderToString} from 'react-dom/server';
import Helmet from 'react-helmet';

const wrapper = (initialProps, context) => {
    const renderedHtml = {
        componentHtml: renderToString(
            <Home />
        ),
        title: Helmet.renderStatic().title.toString()
    };
    return { renderedHtml };
}

ReactOnRails.register({ Home: wrapper });
