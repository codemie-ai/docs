/**
 * Generates theme objects (dark and light) from theme tokens.
 *
 * Takes a nested token structure and generates two separate theme objects:
 * one for dark theme (index 0) and one for light theme (index 1).
 *
 * Token values can be:
 * - Arrays with exactly 2 elements: [darkValue, lightValue] - different colors for each theme
 * - Single string values: sameValueForBothThemes - same color for both themes
 *
 * @param source - The theme tokens object containing nested token definitions
 * @returns Object with `dark` and `light` theme objects
 * @throws {Error} If an array token doesn't have exactly 2 elements
 *
 * @example
 * ```typescript
 * // Example with color palette reference
 * const c = {
 *   neutral: { '925': '#1A1A1A', '0': '#FFFFFF' },
 *   blue: { '400': '#007AFF' }
 * }
 *
 * const tokens = {
 *   surface: {
 *     elevated: [c['neutral']['925'], c['neutral']['0']],  // Array: different for each theme
 *     primary: c['neutral']['925']                          // Single: same for both themes
 *   },
 *   text: {
 *     accent: c['blue']['400']  // Single color - same for dark and light
 *   }
 * }
 *
 * const themes = generateThemes(tokens)
 * // Result:
 * // {
 * //   dark: {
 * //     surface: { elevated: '#1A1A1A', primary: '#1A1A1A' },
 * //     text: { accent: '#007AFF' }
 * //   },
 * //   light: {
 * //     surface: { elevated: '#FFFFFF', primary: '#1A1A1A' },
 * //     text: { accent: '#007AFF' }
 * //   }
 * // }
 * ```
 */
export const generateThemes = (source: Record<string, unknown>) => {
  const parse = (node: unknown, index: number, path: string = 'root'): unknown => {
    // Base Case: If we hit an array, validate and return the specific index
    // Arrays represent [darkTheme, lightTheme]
    if (Array.isArray(node)) {
      if (node.length !== 2) {
        throw new Error(
          `Array token at "${path}" must have exactly 2 elements [darkValue, lightValue], received ${
            node.length
          } element${node.length === 1 ? '' : 's'}`
        );
      }
      return node[index];
    }

    // Base Case: If it's a string value, return as-is
    // This handles single color values that should apply to both themes
    if (typeof node === 'string') {
      return node;
    }

    // Recursive Step: If it's an object, map over keys and parse recursively
    if (typeof node === 'object' && node !== null) {
      return Object.keys(node).reduce<Record<string, unknown>>((acc, key) => {
        const newPath = path === 'root' ? key : `${path}.${key}`;
        acc[key] = parse((node as Record<string, unknown>)[key], index, newPath);
        return acc;
      }, {});
    }

    // Throw for any other type (null, undefined, number, boolean, etc.)
    let receivedType: string;
    if (node === null) {
      receivedType = 'null';
    } else if (node === undefined) {
      receivedType = 'undefined';
    } else {
      receivedType = typeof node;
    }

    throw new Error(
      `Invalid token value at "${path}". Expected string, array [darkValue, lightValue], or object, received ${receivedType}`
    );
  };

  return {
    dark: parse(source, 0),
    light: parse(source, 1),
  };
};
