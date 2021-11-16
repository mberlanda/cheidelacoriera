import { Button } from "./button";
import { Team } from "./team";
import { TransportMean } from "./transportMean";
import { User } from "./user";

interface GameTeams {
  away: Team;
  home: Team;
}

export interface Game {
  availability: number;
  audience?: string;
  buttons?: Button[];
  competition: string;
  currentUser?: User;
  date: string;
  id: number;
  score?: string;
  status?: string;
  teams: GameTeams;
  time: string;
  transportMean: TransportMean;
}