const starter = (webComponentType) => {
    customElements.define(webComponentType, class extends HTMLElement {
        constructor() {
            super();
        }
        connectedCallback() {
            const node = document.createElement("div");
            const shadow = this.attachShadow({ mode: 'open' }).appendChild(node);
            this.app = Elm.Main.init(
                { node: node 
                , flags: 
                    { webComponentType: webComponentType
                    , virtualDomTesting: typeof virtualDomTesting === 'undefined' ? null : virtualDomTesting
                    }
                }
            );
            document.addEventListener("event01", (event) => {
                this.app.ports.attr01.send(event.detail.text);
            });
        }
    });
};

starter('web-component-01');
starter('web-component-02');
