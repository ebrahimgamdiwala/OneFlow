/**
 * @jest-environment node
 */

describe('Health Check', () => {
  it('should pass basic test', () => {
    expect(true).toBe(true);
  });

  it('should validate environment', () => {
    expect(process.env.NODE_ENV).toBe('test');
  });
});
