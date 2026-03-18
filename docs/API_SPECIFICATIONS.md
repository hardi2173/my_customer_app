# API Specifications

## Standard Response Format

All API responses follow this standardized format:

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": {
    // endpoint-specific data
  },
  "timestamp": "2026-03-14 12:03:22",
  "path": "/v1/users/login",
  "requestId": "97815a54-385f-41a4-9a7c-fcc2a2168c80"
}
```

### Response Fields

| Field      | Type   | Description                                     |
| ---------- | ------ | ----------------------------------------------- |
| statusCode | number | HTTP status code                                |
| message    | string | Human-readable message (e.g., "OK", "Created")  |
| data       | object | Endpoint-specific response data                 |
| timestamp  | string | Response timestamp (YYYY-MM-DD HH:mm:ss format) |
| path       | string | Requested endpoint path                         |
| requestId  | string | Unique request identifier for tracing           |

## Error Response Format

```json
{
  "statusCode": 400,
  "message": "Bad Request",
  "error": "Validation failed",
  "timestamp": "2026-03-14 12:03:22",
  "path": "/v1/users/register",
  "requestId": "97815a54-385f-41a4-9a7c-fcc2a2168c80"
}
```

## User Registration

### POST /users/register

Register a new user with profile, addresses, and contacts.

#### Request Body

```json
{
  "username": "string (required, unique)",
  "password": "string (required, min 8 chars, must contain uppercase, lowercase, number, special char)",
  "firstName": "string (optional)",
  "lastName": "string (optional)",
  "pob": "string (optional) - Place of Birth",
  "dob": "string (optional) - Date of Birth (ISO date format)",
  "nationality": "string (optional)",
  "religion": "string (optional)",
  "addresses": [
    {
      "addressType": "HOME | OFFICE | CORRESPONDENCE (optional, default: HOME)",
      "addressProvince": "string (optional)",
      "addressCity": "string (optional)",
      "addressDistrict": "string (optional)",
      "addressSubDistrict": "string (optional)",
      "addressLine1": "string (optional)",
      "addressLine2": "string (optional)"
    }
  ],
  "contacts": [
    {
      "contactType": "HOME | OFFICE | EMAIL | PHONE (required)",
      "contactNumber": "string (required, unique)"
    }
  ]
}
```

#### Response (201 Created)

```json
{
  "statusCode": 201,
  "message": "Created",
  "data": {
    "id": "uuid",
    "username": "string",
    "status": "IN_ACTIVE",
    "profile": {
      "id": "uuid",
      "firstName": "string",
      "lastName": "string"
    }
  },
  "timestamp": "2026-03-14 12:03:22",
  "path": "/v1/users/register",
  "requestId": "97815a54-385f-41a4-9a7c-fcc2a2168c80"
}
```

#### Validation Rules

- **Password**: Must be at least 8 characters and contain:
  - At least one uppercase letter
  - At least one lowercase letter
  - At least one number
  - At least one special character (!@#$%^&\*()\_+-=[]{};':"\\|,.<>/?)
- **Username**: Must be unique in the system
- **contactNumber**: Must be unique in the system

#### Status Codes

- `201 Created` - User registered successfully
- `400 Bad Request` - Validation failed (invalid password format, username or contact number already exists)

## User Login

### POST /users/login

Authenticate a user and generate access/refresh tokens.

#### Headers

| Header    | Required | Description       |
| --------- | -------- | ----------------- |
| device_id | Yes      | Device identifier |

#### Request Body

```json
{
  "username": "string (required)",
  "password": "string (required)"
}
```

#### Response (200 OK)

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": {
    "accessToken": "string (JWE token)",
    "refreshToken": "string (JWE token)",
    "user": {
      "id": "uuid",
      "username": "string",
      "status": "ACTIVE",
      "profile": {
        "id": "uuid",
        "firstName": "string",
        "lastName": "string",
        "pob": "string",
        "dob": "date",
        "nationality": "string",
        "religion": "string"
      }
    }
  },
  "timestamp": "2026-03-14 12:03:22",
  "path": "/v1/users/login",
  "requestId": "97815a54-385f-41a4-9a7c-fcc2a2168c80"
}
```

#### Validation Rules

- **device_id header**: Required for device tracking
- **Username**: Must exist in the system
- **Password**: Must match the stored bcrypt hash
- **User status**: Must be `ACTIVE` to login

#### Device Management

- If the device_id + user_id combination already exists, the last_login is updated
- If new device, maximum 3 devices per user are allowed
- Each login attempt is logged in user_access_log table

#### Status Codes

- `200 OK` - Login successful
- `400 Bad Request` - Maximum devices reached for user
- `401 Unauthorized` - Invalid credentials or user not active

## Get Account Detail

### GET /account/detail

Get full account details including user, profile, contacts, and addresses.

#### Headers

| Authorization | Required | Description  |
| ------------- | -------- | ------------ |
| Bearer token  | Yes      | Access token |

#### Response (200 OK)

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": {
    "id": "uuid",
    "username": "string",
    "status": "ACTIVE",
    "createdAt": "timestamp",
    "profile": {
      "id": "uuid",
      "firstName": "string",
      "lastName": "string",
      "pob": "string",
      "dob": "date",
      "nationality": "string",
      "religion": "string",
      "addresses": [
        {
          "id": "uuid",
          "addressType": "HOME | OFFICE | CORRESPONDENCE",
          "addressProvince": "string",
          "addressCity": "string",
          "addressDistrict": "string",
          "addressSubDistrict": "string",
          "addressLine1": "string",
          "addressLine2": "string"
        }
      ],
      "contacts": [
        {
          "id": "uuid",
          "contactType": "HOME | OFFICE | EMAIL | PHONE",
          "contactNumber": "string"
        }
      ]
    }
  },
  "timestamp": "2026-03-14 12:03:22",
  "path": "/v1/account/detail",
  "requestId": "97815a54-385f-41a4-9a7c-fcc2a2168c80"
}
```

#### Status Codes

- `200 OK` - Account detail retrieved successfully
- `401 Unauthorized` - Invalid or missing token

## Update Account Profile

### PUT /account/profile

Update the authenticated user's profile (personal information only).

#### Headers

| Authorization | Required | Description  |
| ------------- | -------- | ------------ |
| Bearer token  | Yes      | Access token |

#### Request Body

```json
{
  "firstName": "string (optional)",
  "lastName": "string (optional)",
  "pob": "string (optional) - Place of Birth",
  "dob": "string (optional) - Date of Birth (ISO date format)",
  "nationality": "string (optional)",
  "religion": "string (optional)"
}
```

#### Response (200 OK)

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": {
    "id": "uuid",
    "username": "string",
    "status": "ACTIVE",
    "createdAt": "timestamp",
    "profile": {
      "id": "uuid",
      "firstName": "string",
      "lastName": "string",
      "pob": "string",
      "dob": "date",
      "nationality": "string",
      "religion": "string",
      "addresses": [
        {
          "id": "uuid",
          "addressType": "HOME | OFFICE | CORRESPONDENCE",
          "addressProvince": "string",
          "addressCity": "string",
          "addressDistrict": "string",
          "addressSubDistrict": "string",
          "addressLine1": "string",
          "addressLine2": "string"
        }
      ],
      "contacts": [
        {
          "id": "uuid",
          "contactType": "HOME | OFFICE | EMAIL | PHONE",
          "contactNumber": "string"
        }
      ]
    }
  },
  "timestamp": "2026-03-14 12:03:22",
  "path": "/v1/account/profile",
  "requestId": "97815a54-385f-41a4-9a7c-fcc2a2168c80"
}
```

#### Notes

- If a profile does not exist for the user, it will be created
- Addresses and contacts use upsert logic:
  - If `id` is provided in the request, the existing record is updated
  - If `id` is not provided, a new record is created
  - Records that exist in the database but are not in the request are deleted
- Only provided fields will be updated; omitted fields will retain their existing values

#### Status Codes

- `200 OK` - Profile updated successfully
- `400 Bad Request` - Validation failed
- `401 Unauthorized` - Invalid or missing token

## Create Address

### POST /account/addresses

Create a new address for the authenticated user's profile.

#### Headers

| Authorization | Required | Description  |
| ------------- | -------- | ------------ |
| Bearer token  | Yes      | Access token |

#### Request Body

```json
{
  "addressType": "HOME | OFFICE | CORRESPONDENCE (optional, default: HOME)",
  "addressProvince": "string (optional)",
  "addressCity": "string (optional)",
  "addressDistrict": "string (optional)",
  "addressSubDistrict": "string (optional)",
  "addressLine1": "string (optional)",
  "addressLine2": "string (optional)"
}
```

#### Response (201 Created)

```json
{
  "statusCode": 201,
  "message": "Created",
  "data": {
    "id": "uuid",
    "addressType": "HOME",
    "addressProvince": "string",
    "addressCity": "string",
    "addressDistrict": "string",
    "addressSubDistrict": "string",
    "addressLine1": "string",
    "addressLine2": "string"
  },
  "timestamp": "2026-03-14 12:03:22",
  "path": "/v1/account/addresses",
  "requestId": "97815a54-385f-41a4-9a7c-fcc2a2168c80"
}
```

#### Status Codes

- `201 Created` - Address created successfully
- `400 Bad Request` - Validation failed
- `401 Unauthorized` - Invalid or missing token
- `404 Not Found` - Profile not found

## Update Address

### PUT /account/addresses/:id

Update an existing address.

#### Headers

| Authorization | Required | Description  |
| ------------- | -------- | ------------ |
| Bearer token  | Yes      | Access token |

#### Path Parameters

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| id        | uuid | Address ID  |

#### Request Body

```json
{
  "addressType": "HOME | OFFICE | CORRESPONDENCE (optional)",
  "addressProvince": "string (optional)",
  "addressCity": "string (optional)",
  "addressDistrict": "string (optional)",
  "addressSubDistrict": "string (optional)",
  "addressLine1": "string (optional)",
  "addressLine2": "string (optional)"
}
```

#### Response (200 OK)

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": {
    "id": "uuid",
    "addressType": "HOME",
    "addressProvince": "string",
    "addressCity": "string",
    "addressDistrict": "string",
    "addressSubDistrict": "string",
    "addressLine1": "string",
    "addressLine2": "string"
  },
  "timestamp": "2026-03-14 12:03:22",
  "path": "/v1/account/addresses/:id",
  "requestId": "97815a54-385f-41a4-9a7c-fcc2a2168c80"
}
```

#### Status Codes

- `200 OK` - Address updated successfully
- `400 Bad Request` - Validation failed
- `401 Unauthorized` - Invalid or missing token
- `404 Not Found` - Address not found

## Delete Address

### DELETE /account/addresses/:id

Delete an address.

#### Headers

| Authorization | Required | Description  |
| ------------- | -------- | ------------ |
| Bearer token  | Yes      | Access token |

#### Path Parameters

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| id        | uuid | Address ID  |

#### Response (200 OK)

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": null,
  "timestamp": "2026-03-14 12:03:22",
  "path": "/v1/account/addresses/:id",
  "requestId": "97815a54-385f-41a4-9a7c-fcc2a2168c80"
}
```

#### Status Codes

- `200 OK` - Address deleted successfully
- `401 Unauthorized` - Invalid or missing token
- `404 Not Found` - Address not found

## Create Contact

### POST /account/contacts

Create a new contact for the authenticated user's profile.

#### Headers

| Authorization | Required | Description  |
| ------------- | -------- | ------------ |
| Bearer token  | Yes      | Access token |

#### Request Body

```json
{
  "contactType": "HOME | OFFICE | EMAIL | PHONE (optional, default: HOME)",
  "contactNumber": "string (required)"
}
```

#### Response (201 Created)

```json
{
  "statusCode": 201,
  "message": "Created",
  "data": {
    "id": "uuid",
    "contactType": "HOME",
    "contactNumber": "string"
  },
  "timestamp": "2026-03-14 12:03:22",
  "path": "/v1/account/contacts",
  "requestId": "97815a54-385f-41a4-9a7c-fcc2a2168c80"
}
```

#### Status Codes

- `201 Created` - Contact created successfully
- `400 Bad Request` - Validation failed
- `401 Unauthorized` - Invalid or missing token
- `404 Not Found` - Profile not found

## Update Contact

### PUT /account/contacts/:id

Update an existing contact.

#### Headers

| Authorization | Required | Description  |
| ------------- | -------- | ------------ |
| Bearer token  | Yes      | Access token |

#### Path Parameters

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| id        | uuid | Contact ID  |

#### Request Body

```json
{
  "contactType": "HOME | OFFICE | EMAIL | PHONE (optional)",
  "contactNumber": "string (optional)"
}
```

#### Response (200 OK)

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": {
    "id": "uuid",
    "contactType": "HOME",
    "contactNumber": "string"
  },
  "timestamp": "2026-03-14 12:03:22",
  "path": "/v1/account/contacts/:id",
  "requestId": "97815a54-385f-41a4-9a7c-fcc2a2168c80"
}
```

#### Status Codes

- `200 OK` - Contact updated successfully
- `400 Bad Request` - Validation failed
- `401 Unauthorized` - Invalid or missing token
- `404 Not Found` - Contact not found

## Delete Contact

### DELETE /account/contacts/:id

Delete a contact.

#### Headers

| Authorization | Required | Description  |
| ------------- | -------- | ------------ |
| Bearer token  | Yes      | Access token |

#### Path Parameters

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| id        | uuid | Contact ID  |

#### Response (200 OK)

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": null,
  "timestamp": "2026-03-14 12:03:22",
  "path": "/v1/account/contacts/:id",
  "requestId": "97815a54-385f-41a4-9a7c-fcc2a2168c80"
}
```

#### Status Codes

- `200 OK` - Contact deleted successfully
- `401 Unauthorized` - Invalid or missing token
- `404 Not Found` - Contact not found

## Create Product

### POST /products

Create a new product.

#### Headers

| Authorization | Required | Description  |
| ------------- | -------- | ------------ |
| Bearer token  | Yes      | Access token |

#### Request Body

```json
{
  "code": "string (required, unique)",
  "name": "string (required)",
  "type": "INDIVIDU_TRADITIONAL | INDIVIDU_UNITLINK | INDIVIDU_ENDOWMENT | INDIVIDU_PENDIDIKAN | INDIVIDU_HEALTHCARE | GROUP_TERMLIFE | GROUP_HEALTHCARE (required)",
  "marketingChannel": "BANCASSURANCE | DIRECT | DIGITAL (required)",
  "description": "string (optional)"
}
```

#### Response (201 Created)

```json
{
  "statusCode": 201,
  "message": "Created",
  "data": {
    "id": "uuid",
    "code": "string",
    "name": "string",
    "type": "INDIVIDU_TRADITIONAL",
    "marketingChannel": "BANCASSURANCE",
    "description": "string",
    "createdAt": "timestamp"
  },
  "timestamp": "2026-03-14 12:03:22",
  "path": "/v1/products",
  "requestId": "97815a54-385f-41a4-9a7c-fcc2a2168c80"
}
```

#### Status Codes

- `201 Created` - Product created successfully
- `400 Bad Request` - Validation failed or code already exists
- `401 Unauthorized` - Invalid or missing token

## Get All Products

### GET /products

Get all products with pagination.

#### Headers

| Authorization | Required | Description  |
| ------------- | -------- | ------------ |
| Bearer token  | Yes      | Access token |

#### Query Parameters

| Parameter | Type    | Default | Description              |
| --------- | ------- | ------- | ------------------------ |
| page      | integer | 1       | Page number              |
| limit     | integer | 10      | Items per page (max 100) |

#### Response (200 OK)

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": {
    "data": [
      {
        "id": "uuid",
        "code": "string",
        "name": "string",
        "type": "INDIVIDU_TRADITIONAL",
        "marketingChannel": "BANCASSURANCE",
        "description": "string",
        "createdAt": "timestamp",
        "updatedAt": "timestamp"
      }
    ],
    "meta": {
      "total": 7,
      "page": 1,
      "limit": 10,
      "totalPages": 1
    }
  },
  "timestamp": "2026-03-14 12:03:22",
  "path": "/v1/products",
  "requestId": "97815a54-385f-41a4-9a7c-fcc2a2168c80"
}
```

#### Status Codes

- `200 OK` - Products retrieved successfully
- `401 Unauthorized` - Invalid or missing token

## Get Product by ID

### GET /products/:id

Get a product by ID.

#### Headers

| Authorization | Required | Description  |
| ------------- | -------- | ------------ |
| Bearer token  | Yes      | Access token |

#### Path Parameters

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| id        | uuid | Product ID  |

#### Response (200 OK)

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": {
    "id": "uuid",
    "code": "string",
    "name": "string",
    "type": "INDIVIDU_TRADITIONAL",
    "marketingChannel": "BANCASSURANCE",
    "description": "string",
    "createdAt": "timestamp",
    "updatedAt": "timestamp"
  },
  "timestamp": "2026-03-14 12:03:22",
  "path": "/v1/products/:id",
  "requestId": "97815a54-385f-41a4-9a7c-fcc2a2168c80"
}
```

#### Status Codes

- `200 OK` - Product retrieved successfully
- `401 Unauthorized` - Invalid or missing token
- `404 Not Found` - Product not found

## Update Product

### PUT /products/:id

Update an existing product.

#### Headers

| Authorization | Required | Description  |
| ------------- | -------- | ------------ |
| Bearer token  | Yes      | Access token |

#### Path Parameters

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| id        | uuid | Product ID  |

#### Request Body

```json
{
  "code": "string (optional, unique)",
  "name": "string (optional)",
  "type": "INDIVIDU_TRADITIONAL | INDIVIDU_UNITLINK | INDIVIDU_ENDOWMENT | INDIVIDU_PENDIDIKAN | INDIVIDU_HEALTHCARE | GROUP_TERMLIFE | GROUP_HEALTHCARE (optional)",
  "marketingChannel": "BANCASSURANCE | DIRECT | DIGITAL (optional)",
  "description": "string (optional)"
}
```

#### Response (200 OK)

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": {
    "id": "uuid",
    "code": "string",
    "name": "string",
    "type": "INDIVIDU_TRADITIONAL",
    "marketingChannel": "BANCASSURANCE",
    "description": "string",
    "createdAt": "timestamp",
    "updatedAt": "timestamp"
  },
  "timestamp": "2026-03-14 12:03:22",
  "path": "/v1/products/:id",
  "requestId": "97815a54-385f-41a4-9a7c-fcc2a2168c80"
}
```

#### Status Codes

- `200 OK` - Product updated successfully
- `400 Bad Request` - Validation failed or code already exists
- `401 Unauthorized` - Invalid or missing token
- `404 Not Found` - Product not found

## Delete Product

### DELETE /products/:id

Delete a product.

#### Headers

| Authorization | Required | Description  |
| ------------- | -------- | ------------ |
| Bearer token  | Yes      | Access token |

#### Path Parameters

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| id        | uuid | Product ID  |

#### Response (200 OK)

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": null,
  "timestamp": "2026-03-14 12:03:22",
  "path": "/v1/products/:id",
  "requestId": "97815a54-385f-41a4-9a7c-fcc2a2168c80"
}
```

#### Status Codes

- `200 OK` - Product deleted successfully
- `401 Unauthorized` - Invalid or missing token
- `404 Not Found` - Product not found
