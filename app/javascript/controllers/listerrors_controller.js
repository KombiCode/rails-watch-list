import { Controller } from "stimulus"

export default class extends Controller {
  next(event) {
    // Hide error display area in case modal was dismissed
    if (document.getElementById('error_explanation')) {
      document.getElementById('error_explanation').style.display = 'none';
    }
  }
}


