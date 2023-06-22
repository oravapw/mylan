import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
    static targets = ['item', 'button']
    static classes = ['hidden']

    connect () {
        this.class = this.hasHiddenClass ? this.hiddenClass : 'hidden'
    }

    toggle () {
        var isHidden
        this.itemTargets.forEach(item => {
            isHidden = item.classList.toggle(this.class)
        })
        if (this.hasButtonTarget) {
            console.log('hidden ' + isHidden, this.buttonTarget)
            const text = isHidden ?
                this.buttonTarget.dataset.showText :
                this.buttonTarget.dataset.hideText
            if (text) {
                this.buttonTarget.innerText = text
            }
        }
    }
}
