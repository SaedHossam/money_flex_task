<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateCustomerRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        $customerId = $this->route('customer')->id;
        return [
            'name' => 'required|string',
            'email' => 'nullable|email|unique:customers,email,' . $customerId,
            'phone' => 'nullable|string',
            'iban' => [
                'required',
                'string',
                'size:24',
                'unique:customers,iban,' . $customerId,
                function ($attribute, $value, $fail) {
                    if (!preg_match('/^SA\d{22}$/', strtoupper($value))) {
                        $fail('The ' . $attribute . ' must be a valid Saudi IBAN.');
                    }
                }
            ],
        ];
    }
}
