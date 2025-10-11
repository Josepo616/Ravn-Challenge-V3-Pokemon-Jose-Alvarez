# Pokedex

A modern Pokédex app built with SwiftUI and SwiftData, following a clean and modular MVVM + Repository architecture.  
The project integrates local persistence, async networking, and smooth UI updates with real Pokémon data from the public PokeAPI.

## Project Description

Pokedex is an iOS application that displays **comprehensive Pokémon information**, including their **types**, **stats**, **evolution chains**, **abilities**, and **descriptions**.  

It provides both a **list view** for browsing Pokémon and a **detail view** for exploring individual Pokémon data in depth.  

The application supports:

- Fetching Pokémon and detailed data from the [PokeAPI](https://pokeapi.co)
- Caching and local persistence using **SwiftData**
- Smooth pagination (“load more”) behavior on the main list
- Real-time search filtering by Pokémon name
- Offline resilience with graceful fallback and error handling
- Reactive and dynamic UI updates powered by `@Published` properties in `ListVM`
- A **detail view** that displays:
  - Base stats (HP, Attack, Defense, etc.)
  - Evolution chain navigation
  - Pokémon type indicators with color coding
  - Descriptive text entries and sprite gallery

## General Overview of the Architecture

The app is structured using the MVVM + Repository pattern and built on top of SwiftData for persistence.

>
#### App Architecture

<img src="https://github.com/Josepo616/Ravn-Challenge-V3-Pokemon-Jose-Alvarez/blob/ios-nerdery-ravn-final-challenge/Images/Project%20Architecture.png" alt="App Architecture" width="400" />


### 🔹 Layers

#### View Layer (SwiftUI)

- **MainList**: Displays Pokémon cards, integrates search and pagination.
- **PokemonKingFisherImage**: Handles asynchronous image loading with placeholders using Kingfisher.

#### ViewModel Layer

- **ListVM**: Central state manager that handles data fetching, pagination, and search logic.  
  Uses `@Published` properties to notify SwiftUI views of state updates.

#### Repository Layer

- **PokemonRepository** (via `PokemonRepositoryProtocol`):  
  Abstracts the data access logic — decides whether to load from cache (SwiftData) or fetch from the API.  
  Decouples networking logic from ViewModels, allowing for easy unit testing.

#### Networking Layer

- **PokeApiService**:  
  Builds the correct endpoint URLs based on parameters and endpoint cases.  
  Uses async/await for network calls and handles query parameters dynamically.

#### Persistence Layer

- **SwiftData models** (`PokemonsEntity`, `PokedexEntity`, `NextEvolutionEntity`, `PokemonTypeEntity`):  
  Enable relational persistence.  
  Use `@Model` and `@Relationship` for structured data.  
  Configured with a shared ModelContainer initialized in `PokedexApp`.

## Setup & Running Instructions

Follow these steps to build and run the project locally.

### Requirements

- macOS 14.0 or later
- Xcode 16 or later
- iOS 17 SDK (for SwiftData support)
- Internet connection (for fetching Pokémon data)

### Steps

1. Clone the repository

    ```bash
    git clone https://github.com/<your-username>/Pokedex.git
    cd Pokedex
    ```

2. Open the project in Xcode

    ```bash
    open Pokedex.xcodeproj
    ```

3. Build and run the app

- Select the iPhone simulator (e.g., iPhone 16 Pro)
- Press ⌘ + R

4. Run the tests

    ```bash
    ⌘ + U
    ```

Tests include unit coverage for `ListVM` and the repository using mock data and fake responses.

## Gifs / Screenshots

> 

#### 1. **Initial Error Screen**
This image shows what the user will see when an error occurs, possibly during an API call failure or network issue.

<img src="https://github.com/Josepo616/Ravn-Challenge-V3-Pokemon-Jose-Alvarez/blob/ios-nerdery-ravn-final-challenge/Images/Initial%20Error%20Screen.png" alt="Initial Error Screen" width="400" />

#### 2. **Failed Search Screen**
This screen is shown when the user searches for a Pokémon and the system cannot find any matching results.

<img src="https://github.com/Josepo616/Ravn-Challenge-V3-Pokemon-Jose-Alvarez/blob/ios-nerdery-ravn-final-challenge/Images/Failed%20Search%20Screen.png" alt="Failed Search Screen" width="400" />

#### 3. **Main List Screen**
This is the main screen where users can see a list of Pokémon cards, which can be paginated and filtered based on the search term.

<img src="https://github.com/Josepo616/Ravn-Challenge-V3-Pokemon-Jose-Alvarez/blob/ios-nerdery-ravn-final-challenge/Images/Main%20List%20Screen.png" alt="Main List Screen" width="400" />

#### 4. **Pokemon Detail Screen**
This screen displays detailed information about an individual Pokémon, such as its stats, evolution chain, and type indicators.

<img src="https://github.com/Josepo616/Ravn-Challenge-V3-Pokemon-Jose-Alvarez/blob/ios-nerdery-ravn-final-challenge/Images/Pokemon%20Detail%20Screen.png" alt="Pokemon Detail Screen" width="400" />

#### 5. **Detail Flow Video**
A short video demonstrating the flow from the main list to the Pokémon detail screen, showing the user experience when interacting with the app.

[Detail Flow Video](https://github.com/Josepo616/Ravn-Challenge-V3-Pokemon-Jose-Alvarez/blob/ios-nerdery-ravn-final-challenge/Gif/Detail%20Flow.mp4)

---

## Assumptions & Design Choices

- **Offline support**: The app persists data using SwiftData so Pokémon data remains available even without internet access.
- **SwiftData** chosen over CoreData: For simplicity, modern syntax, and native Swift integration.
- **Kingfisher** used for image caching: Improves performance and simplifies asynchronous image loading.
- **Error handling** centralized via `PokemonError`: Provides user-friendly descriptions and better debugging.

**MVVM + Repository** chosen to:

- Decouple UI and data logic
- Simplify testing via dependency injection (`PokemonRepositoryProtocol`)
- Improve maintainability and scalability

## Technologies Used

| Layer        | Technology                   | Purpose                                         |
|--------------|------------------------------|-------------------------------------------------|
| **UI**       | SwiftUI                      | Declarative UI and reactive state updates      |
| **Persistence** | SwiftData                  | Local database and caching                      |
| **Networking** | URLSession + async/await    | REST API calls to PokeAPI                      |
| **Image Loading** | Kingfisher               | Asynchronous image downloading & caching       |
| **Architecture** | MVVM + Repository        | Clean separation of concerns                   |
| **Testing**   | XCTest                       | Unit testing with mock repositories            |
| **Language**  | Swift 5.10+                  | Modern concurrency and SwiftData support       |

## Testing Strategy

The project includes unit tests focused on the core logic (ViewModel):

- **FakeRepository** to simulate API calls and SwiftData responses.
- **Given / When / Then** testing style for readability.

Tests cover:

- Successful fetch and pagination
- Error mapping (e.g., connectivity issues)
- Search filtering
- State restoration (`clearSearch`, `isFetchingMore` toggling)
- Early-return optimizations in `fetchPokemons`

## Author

**José Álvarez**  
Software Engineer  
[GitHub Profile](https://github.com/josepo616)
