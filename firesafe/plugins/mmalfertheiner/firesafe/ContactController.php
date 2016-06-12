<?php namespace Mmalfertheiner\Firesafe;

use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Mail;

class ContactController extends Controller {

    use ValidatesRequests;

    /**
     * @param ContactRequest $request
     * @return $this
     */
    public function postContact(ContactRequest $request) {

        $data = $request->all();

        Mail::send('mmalfertheiner.firesafe::emails.contact', ['data' => $data], function($message) {

            $message->to('martin.malfertheiner@gmail.com', 'Martin Malfertheiner');
            $message->subject('Firesafe Kontaktanfrage');

        });

        return redirect()
            ->back()
            ->withInput($request->only('email'))
            ->withErrors([
                'email' => trans('auth.invalid_credentials'),
            ]);
    }

}
