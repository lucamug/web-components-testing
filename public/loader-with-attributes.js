const getAttrs = (el) => {
    const attrs = {};
    for (let i = 0; i < el.attributes.length; i++) {
        attrs[el.attributes[i].name] = el.attributes[i].value;
    }
    return (attrs);
};

const starter = (webComponentType) => {
    customElements.define(webComponentType, class extends HTMLElement {
        constructor() {
            super();
            this.observer1 = new MutationObserver(() => {
                this.app.ports.attr01.send(getAttrs(this).attr01);
            });
            this.observer1.observe(this, { attributes: true });
        }
        connectedCallback() {
            const node = document.createElement("div");
            const shadow = this.attachShadow({ mode: 'open' }).appendChild(node);
            this.app = Elm.Main.init(
                { node: node 
                , flags: 
                    { attr01: getAttrs(this).attr01
                    , webComponentType: webComponentType
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
