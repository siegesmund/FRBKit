import Foundation
import Combine

public extension Fred {
    enum CommonSeries: String {
        
        // MARK: Common US Economic Series
        case CDRatesNonJumbo                = "MMNRNJ"          // FDIC via FRED
        case CDRatesJumbo                   = "MMNRJD"          // FDIC via FRED
        case RealGDP                        = "A191RL1Q225SBEA" // BEA via FRED
        case ConsumerPriceIndex             = "CPIAUCSL"        // Board of Governors of the Federal Reserve System
        case CreditCardInterestRate         = "TERMCBCCALLNS"   // Board of Governors of the Federal Reserve System
        case FederalFundsRate               = "FEDFUNDS"        // Board of Governors of the Federal Reserve System
        case InitialClaimsFourWeekMovingAvg = "IC4WSA"          // US Employment & Training Admin via FRED
        case IndustrialProductionIndex      = "INDPRO"          // Board of Governors of the Federal Reserve System
        case InstitutionalMoneyFunds        = "WIMFSL"
        case MortgageRates30USFixedAverage  = "MORTGAGE30US"    // Freddie Mac via Board of Governors of the Federal Reserve System
        case MortgageRates15USFixedAverage  = "MORTGAGE15US"    // Freddie Mac via Board of Governors of the Federal Reserve System
        case MortgageRates5USFixedAverage   = "MORTGAGE5US"     // Freddie Mac via Board of Governors of the Federal Reserve System
        case TotalHousingStarts             = "HOUST"           // U.S. Census Bureau and U.S. Department of Housing and Urban Development
        case TotalPayrolls                  = "PAYEMS"          // U.S. Bureau of Labor Statistics
        case TotalVehicleSales              = "TOTALSA"         // U.S. Bureau of Economic Analysis
        case RetailMoneyFunds               = "WRMFSL"          // Board of Governors of the Federal Reserve System
        case UnemploymentRate               = "UNRATE"          // U.S. Bureau of Labor Statistics
        case USRecessionProbabilities       = "RECPROUSM156N"   // U.S. Bureau of Economic Analysis
        case TenYearTreasuryConstantMaturityRate = "DGS10"      // Board of Governors of the Federal Reserve System
        
        // MARK: Financial Index Time Series
        case SP500                          = "SP500"           // S&P Dow Jones Indices LLC
        case NasdaqComposite                = "NASDAQCOM"       // NASDAQ OMX Group
        case Nasdaq100Index                 = "NASDAQ100"       // NASDAQ OMX Group
        case DowJonesIndustrialAverage      = "DJIA"            // S&P Dow Jones Indices LLC
        
    }
    
    /*
    * Common queries
    */
    
    static func series(seriesId: String) -> AnyPublisher<Fred.Result, Error> {
        return Fred.Query(series: .Observations)
            .with(.APIKey, value: fredAPIKey)
            .with(.SeriesId, value: seriesId)
            .fetch()
    }
    
    static func series(seriesId: CommonSeries) -> AnyPublisher<Fred.Result,Error> {
        return series(seriesId: seriesId.rawValue)
    }
    
    // Requires a global variable 'fredAPIKey' with the api key
    static func seriesSync(seriesId: String) throws -> Fred.Result {
        return try Fred.Query(series: .Observations)
            .with(.APIKey, value: fredAPIKey)
            .with(.SeriesId, value: seriesId)
            .fetchSync()
    }
    
    static func updatesSync(offset: Int = 0, limit: Int = 1000) throws -> [Fred.Series] {
        return try Fred.Query(series: .Updates)
            .with(.APIKey, value: fredAPIKey)
            .with(.Offset, value: String(offset))
            .with(.Limit, value: String(limit))
            .fetchSync()
            .series ?? []
    }
    
    static func initializeUpdatesSync() throws -> [Fred.Series] {
        var offset = 0
        var accumulator: [Fred.Series] = []
        var updates = try updatesSync(offset: offset)
        accumulator.append(contentsOf: updates)
        while updates.count > 0 {
            updates = try updatesSync(offset: offset)
            accumulator.append(contentsOf: updates)
            offset += 1000
        }
        return accumulator
    }
}
