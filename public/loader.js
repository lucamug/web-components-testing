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
            this.handleXYZ = (event) => {
                this.app.ports.portXYZ.send(event.detail.text);
            }
            document.addEventListener("eventXYZ", this.handleXYZ);
        }
        disconnectedCallback(event) {
            this.app.ports.unmount.send(null);
            document.removeEventListener("eventXYZ", this.handleXYZ);
        };
    });
};

starter('web-component-01');
starter('web-component-02');
