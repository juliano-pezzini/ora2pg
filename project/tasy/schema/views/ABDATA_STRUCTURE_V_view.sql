-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW abdata_structure_v (nm_tabela, nm_atributo, ie_identificador) AS select 'SZI_MED' nm_tabela, 'KEY_INT' nm_atributo, lpad('1',2,0) ie_identificador
union all

select 'SZI_MED' nm_tabela, 'KEY_STO' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'SZI_MED' nm_tabela, 'LOKALISATION' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'INT_MED' nm_tabela, 'KEY_INT' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'INT_MED' nm_tabela, 'DAT_AKTUALISIERUNG' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'INT_MED' nm_tabela, 'EFFEKT_KURZ' nm_atributo, lpad('4',2,0) ie_identificador  
union all

select 'INT_MED' nm_tabela, 'KENNTNISSTAND_DYN' nm_atributo, lpad('5',2,0) ie_identificador  
union all

select 'INT_MED' nm_tabela, 'KENNTNISSTAND_KIN' nm_atributo, lpad('6',2,0) ie_identificador  
union all

select 'INT_MED' nm_tabela, 'KENNTNISSTAND_SON' nm_atributo, lpad('7',2,0) ie_identificador  
union all

select 'INT_MED' nm_tabela, 'MASSNAHMEN' nm_atributo, lpad('13',2,0) ie_identificador  
union all

select 'INT_MED' nm_tabela, 'MECHANISMUS_DYN' nm_atributo, lpad('8',2,0) ie_identificador  
union all

select 'INT_MED' nm_tabela, 'MECHANISMUS_KIN' nm_atributo, lpad('9',2,0) ie_identificador  
union all

select 'INT_MED' nm_tabela, 'MECHANISMUS_SON' nm_atributo, lpad('10',2,0) ie_identificador  
union all

select 'INT_MED' nm_tabela, 'NAME_LINKS' nm_atributo, lpad('11',2,0) ie_identificador  
union all

select 'INT_MED' nm_tabela, 'NAME_RECHTS' nm_atributo, lpad('12',2,0) ie_identificador  
union all

select 'ITX_MED' nm_tabela, 'KEY_INT' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'ITX_MED' nm_tabela, 'TEXTFELD' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'ITX_MED' nm_tabela, 'TEXT' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'ARE_MED' nm_tabela, 'PZN' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'ARE_MED' nm_tabela, 'KEY_FAM' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'FZI_MED' nm_tabela, 'KEY_INT' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'FZI_MED' nm_tabela, 'KEY_STO' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'FZI_MED' nm_tabela, 'KEY_FAM' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'STA_MED' nm_tabela, 'KEY_STA' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'STA_MED' nm_tabela, 'TEXT' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'FAS_MED' nm_tabela, 'KEY_FAM' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'FAS_MED' nm_tabela, 'KEY_STA' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'ADF_MED' nm_tabela, 'KEY_ADF' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'ADF_MED' nm_tabela, 'KURZNAME' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'ADF_MED' nm_tabela, 'LAND' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'ADF_MED' nm_tabela, 'LANGNAME' nm_atributo, lpad('4',2,0) ie_identificador  
union all

select 'ADF_MED' nm_tabela, 'ORT_POSTFACH' nm_atributo, lpad('5',2,0) ie_identificador  
union all

select 'ADF_MED' nm_tabela, 'ORT_ZUSTELLUNG' nm_atributo, lpad('6',2,0) ie_identificador  
union all

select 'ADF_MED' nm_tabela, 'PLZ_POSTFACH' nm_atributo, lpad('7',2,0) ie_identificador  
union all

select 'ADF_MED' nm_tabela, 'PLZ_ZUSTELLUNG' nm_atributo, lpad('8',2,0) ie_identificador  
union all

select 'ADF_MED' nm_tabela, 'POSTFACH' nm_atributo, lpad('9',2,0) ie_identificador  
union all

select 'ADF_MED' nm_tabela, 'STRASSE' nm_atributo, lpad('10',2,0) ie_identificador  
union all

select 'ADF_MED' nm_tabela, 'TELEFAX' nm_atributo, lpad('11',2,0) ie_identificador  
union all

select 'ADF_MED' nm_tabela, 'TELEFON' nm_atributo, lpad('12',2,0) ie_identificador  
union all

select 'ATC_MED' nm_tabela, 'KEY_ATC' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'ATC_MED' nm_tabela, 'NAME_DEUTSCH' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'ATC_MED' nm_tabela, 'DDD' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'ATCA_MED' nm_tabela, 'KEY_ATCA' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'ATCA_MED' nm_tabela, 'DDD' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'ATCA_MED' nm_tabela, 'NAME' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'AAZF_MED' nm_tabela, 'KEY_FAM' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'AAZF_MED' nm_tabela, 'KEY_ATCA' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'DAF_MED' nm_tabela, 'KEY_DAF' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'DAF_MED' nm_tabela, 'NAME' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'FAT_MED' nm_tabela, 'KEY_FAT' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'FAT_MED' nm_tabela, 'DAT_AKTUALISIERUNG' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'FAT_MED' nm_tabela, 'DOSIERUNG' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'FAT_MED' nm_tabela, 'INDIKATIONEN' nm_atributo, lpad('4',2,0) ie_identificador  
union all

select 'FAT_MED' nm_tabela, 'KONTRAINDIKATIONEN' nm_atributo, lpad('5',2,0) ie_identificador  
union all

select 'FAT_MED' nm_tabela, 'NEBENWIRKUNGEN' nm_atributo, lpad('6',2,0) ie_identificador  
union all

select 'FAT_MED' nm_tabela, 'VERORDNERHINWEISE' nm_atributo, lpad('7',2,0) ie_identificador  
union all

select 'IND_MED' nm_tabela, 'KEY_IND' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'IND_MED' nm_tabela, 'NAME' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'KEY_FAM' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'ABGABEBESTIMMUNG' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'AUFBRAUCH_KS_EINHEIT' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'AUFBRAUCH_KS_ZAHL' nm_atributo, lpad('4',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'AUFBRAUCH_RT_EINHEIT' nm_atributo, lpad('5',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'AUFBRAUCH_RT_ZAHL' nm_atributo, lpad('6',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'DAT_AUSBIETUNG' nm_atributo, lpad('7',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'DAT_ERSTERFASSUNG' nm_atributo, lpad('8',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'DAT_ZUSAMMENSETZUNG' nm_atributo, lpad('9',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'EMA_ZULASSUNG' nm_atributo, lpad('10',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'EINMALIGE_ANWENDUNG' nm_atributo, lpad('11',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'FEUCHTIGKEITSSCHUTZ' nm_atributo, lpad('12',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'INFO_AUFBEWAHRUNG' nm_atributo, lpad('13',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'KEY_ADF_ANBIETER' nm_atributo, lpad('14',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'KEY_ADF_MITVERTRIEB' nm_atributo, lpad('15',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'KEY_ATC' nm_atributo, lpad('16',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'KEY_ATCA' nm_atributo, lpad('28',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'KEY_DAF' nm_atributo, lpad('17',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'KEY_FAT' nm_atributo, lpad('18',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'KEY_IND_HAUPT' nm_atributo, lpad('19',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'KEY_IND_NEBEN' nm_atributo, lpad('20',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'LICHTSCHUTZ' nm_atributo, lpad('21',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'MONOPRAEPARAT' nm_atributo, lpad('22',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'PRODUKTGRUPPE' nm_atributo, lpad('23',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'PRODUKTNAME' nm_atributo, lpad('24',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'SOFORTIGER_VERBRAUCH' nm_atributo, lpad('25',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'THERAPIERICHTUNG_AM' nm_atributo, lpad('29',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'VERKEHRSSTATUS' nm_atributo, lpad('26',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'VETERINAERPRAEPARAT' nm_atributo, lpad('27',2,0) ie_identificador  
union all

select 'FAM_MED' nm_tabela, 'ZUSAETZ_UEBERWACHUNG' nm_atributo, lpad('30',2,0) ie_identificador  
union all

select 'STO_MED' nm_tabela, 'KEY_STO' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'STO_MED' nm_tabela, 'ANTHROPOSOPHIKUM' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'STO_MED' nm_tabela, 'BTMG_ANLAGE' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'STO_MED' nm_tabela, 'CHEMIKALIE' nm_atributo, lpad('4',2,0) ie_identificador  
union all

select 'STO_MED' nm_tabela, 'CO_STOFF' nm_atributo, lpad('5',2,0) ie_identificador  
union all

select 'STO_MED' nm_tabela, 'HILFSSTOFF' nm_atributo, lpad('6',2,0) ie_identificador  
union all

select 'STO_MED' nm_tabela, 'HOMOEOPATHIKUM' nm_atributo, lpad('7',2,0) ie_identificador  
union all

select 'STO_MED' nm_tabela, 'LEBENSMITTELZUSATZ' nm_atributo, lpad('9',2,0) ie_identificador  
union all

select 'STO_MED' nm_tabela, 'NAHRUNGSGENUSSMITTEL' nm_atributo, lpad('10',2,0) ie_identificador  
union all

select 'STO_MED' nm_tabela, 'PFLANZENSCHUTZMITTEL' nm_atributo, lpad('11',2,0) ie_identificador  
union all

select 'STO_MED' nm_tabela, 'STOFF_IN_KOSMETIKA' nm_atributo, lpad('8',2,0) ie_identificador  
union all

select 'STO_MED' nm_tabela, 'WIRKSTOFF' nm_atributo, lpad('12',2,0) ie_identificador  
union all

select 'STX_MED' nm_tabela, 'KEY_STO' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'STX_MED' nm_tabela, 'TEXTFELD' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'STX_MED' nm_tabela, 'TEXT' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'FAI_MED' nm_tabela, 'KEY_FAM' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'FAI_MED' nm_tabela, 'KOMPONENTENNR' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'FAI_MED' nm_tabela, 'RANG' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'FAI_MED' nm_tabela, 'EINHEIT' nm_atributo, lpad('4',2,0) ie_identificador  
union all

select 'FAI_MED' nm_tabela, 'ENTSPRICHTSTOFF' nm_atributo, lpad('5',2,0) ie_identificador  
union all

select 'FAI_MED' nm_tabela, 'KEY_STO' nm_atributo, lpad('6',2,0) ie_identificador  
union all

select 'FAI_MED' nm_tabela, 'STOFFTYP' nm_atributo, lpad('7',2,0) ie_identificador  
union all

select 'FAI_MED' nm_tabela, 'SUFFIX' nm_atributo, lpad('8',2,0) ie_identificador  
union all

select 'FAI_MED' nm_tabela, 'VERGLEICH' nm_atributo, lpad('10',2,0) ie_identificador  
union all

select 'FAI_MED' nm_tabela, 'VERWENDUNG_INTERN' nm_atributo, lpad('11',2,0) ie_identificador  
union all

select 'FAI_MED' nm_tabela, 'ZAHL' nm_atributo, lpad('9',2,0) ie_identificador  
union all

select 'INR_MED' nm_tabela, 'KEY_IND' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'INR_MED' nm_tabela, 'ZAEHLER' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'INR_MED' nm_tabela, 'NAME' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'INV_MED' nm_tabela, 'KEY_IND_QUELLE' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'INV_MED' nm_tabela, 'KEY_IND_ZIEL' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'SNA_MED' nm_tabela, 'KEY_STO' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'SNA_MED' nm_tabela, 'ZAEHLER' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'SNA_MED' nm_tabela, 'HERKUNFT' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'SNA_MED' nm_tabela, 'NAME' nm_atributo, lpad('4',2,0) ie_identificador  
union all

select 'SNA_MED' nm_tabela, 'SORTIERBEGRIFF' nm_atributo, lpad('5',2,0) ie_identificador  
union all

select 'SNA_MED' nm_tabela, 'SUCHBEGRIFF' nm_atributo, lpad('6',2,0) ie_identificador  
union all

select 'SNA_MED' nm_tabela, 'VORZUGSBEZEICHNUNG' nm_atributo, lpad('7',2,0) ie_identificador  
union all

select 'SZG_MED' nm_tabela, 'KEY_SGR' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'SZG_MED' nm_tabela, 'KEY_STO' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'ESC_MED' nm_tabela, 'KEY_STO' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'ESC_MED' nm_tabela, 'EXTERNER_CODE' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'ESC_MED' nm_tabela, 'TYP' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'HEK_MED' nm_tabela, 'KEY_HEK' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'HEK_MED' nm_tabela, 'KURZFORM' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'HEK_MED' nm_tabela, 'LANGFORM' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'SGR_MED' nm_tabela, 'KEY_SGR' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'SGR_MED' nm_tabela, 'DEFINITION' nm_atributo, lpad('4',2,0) ie_identificador  
union all

select 'SGR_MED' nm_tabela, 'NAME' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'SGR_MED' nm_tabela, 'TYP' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'FAK_MED' nm_tabela, 'KEY_FAM' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'FAK_MED' nm_tabela, 'KOMPONENTENNR' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'FAK_MED' nm_tabela, 'ABGABEFORM' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'FAK_MED' nm_tabela, 'ABSOLUTBEZUG_EINHEIT' nm_atributo, lpad('4',2,0) ie_identificador  
union all

select 'FAK_MED' nm_tabela, 'ABSOLUTBEZUG_ZAHL' nm_atributo, lpad('5',2,0) ie_identificador  
union all

select 'FAK_MED' nm_tabela, 'BRENNWERT' nm_atributo, lpad('6',2,0) ie_identificador  
union all

select 'FAK_MED' nm_tabela, 'BROTEINHEITEN' nm_atributo, lpad('7',2,0) ie_identificador  
union all

select 'FAK_MED' nm_tabela, 'ETHANOLGEHALT' nm_atributo, lpad('8',2,0) ie_identificador  
union all

select 'FAK_MED' nm_tabela, 'FREISETZUNG' nm_atributo, lpad('9',2,0) ie_identificador  
union all

select 'FAK_MED' nm_tabela, 'GALENISCHE_GRUNDFORM' nm_atributo, lpad('10',2,0) ie_identificador  
union all

select 'FAK_MED' nm_tabela, 'KOMPONENTENNAME' nm_atributo, lpad('11',2,0) ie_identificador  
union all

select 'FAK_MED' nm_tabela, 'RELATIVBEZUG_EINHEIT' nm_atributo, lpad('12',2,0) ie_identificador  
union all

select 'FAK_MED' nm_tabela, 'RELATIVBEZUG_FORM' nm_atributo, lpad('13',2,0) ie_identificador  
union all

select 'FAK_MED' nm_tabela, 'RELATIVBEZUG_ZAHL' nm_atributo, lpad('14',2,0) ie_identificador  
union all

select 'FAK_MED' nm_tabela, 'STATUS_HILFSSTOFFE' nm_atributo, lpad('15',2,0) ie_identificador  
union all

select 'FAP_MED' nm_tabela, 'KEY_FAM' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'FAP_MED' nm_tabela, 'KOMPONENTENNR' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'FAP_MED' nm_tabela, 'ZAEHLER' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'FAP_MED' nm_tabela, 'ANWENDUNGSFORM' nm_atributo, lpad('4',2,0) ie_identificador  
union all

select 'FAP_MED' nm_tabela, 'APPLIKATIONSART' nm_atributo, lpad('5',2,0) ie_identificador  
union all

select 'FAP_MED' nm_tabela, 'APPLIKATIONSORT' nm_atributo, lpad('6',2,0) ie_identificador  
union all

select 'FAP_MED' nm_tabela, 'APPLIKATIONSWEG' nm_atributo, lpad('7',2,0) ie_identificador  
union all

select 'FAP_MED' nm_tabela, 'ZUBEREITUNG' nm_atributo, lpad('8',2,0) ie_identificador  
union all

select 'ADA_MED' nm_tabela, 'KEY_ADA' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'ADA_MED' nm_tabela, 'FIRMENNAME' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'ADA_MED' nm_tabela, 'FIRMENNAME_2' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'ADA_MED' nm_tabela, 'FIRMENNAME_3' nm_atributo, lpad('4',2,0) ie_identificador  
union all

select 'ADA_MED' nm_tabela, 'HAUSNR_BIS' nm_atributo, lpad('5',2,0) ie_identificador  
union all

select 'ADA_MED' nm_tabela, 'HAUSNR_BIS_ZUSATZ' nm_atributo, lpad('6',2,0) ie_identificador  
union all

select 'ADA_MED' nm_tabela, 'HAUSNR_VON' nm_atributo, lpad('7',2,0) ie_identificador  
union all

select 'ADA_MED' nm_tabela, 'HAUSNR_VON_ZUSATZ' nm_atributo, lpad('8',2,0) ie_identificador  
union all

select 'ADA_MED' nm_tabela, 'LAND' nm_atributo, lpad('9',2,0) ie_identificador  
union all

select 'ADA_MED' nm_tabela, 'ORT_POSTFACH' nm_atributo, lpad('10',2,0) ie_identificador  
union all

select 'ADA_MED' nm_tabela, 'ORT_ZUSTELLUNG' nm_atributo, lpad('11',2,0) ie_identificador  
union all

select 'ADA_MED' nm_tabela, 'PLZ_GROSSKUNDE' nm_atributo, lpad('12',2,0) ie_identificador  
union all

select 'ADA_MED' nm_tabela, 'PLZ_POSTFACH' nm_atributo, lpad('13',2,0) ie_identificador  
union all

select 'ADA_MED' nm_tabela, 'PLZ_ZUSTELLUNG' nm_atributo, lpad('14',2,0) ie_identificador  
union all

select 'ADA_MED' nm_tabela, 'POSTFACH' nm_atributo, lpad('15',2,0) ie_identificador  
union all

select 'ADA_MED' nm_tabela, 'SORTIERNAME' nm_atributo, lpad('16',2,0) ie_identificador  
union all

select 'ADA_MED' nm_tabela, 'STRASS' nm_atributo, lpad('17',2,0) ie_identificador  
union all

select 'SER_MED' nm_tabela, 'KEY_ADA' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'SER_MED' nm_tabela, 'ZAEHLER' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'SER_MED' nm_tabela, 'ADRESSE' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'SER_MED' nm_tabela, 'ADRESSTYP' nm_atributo, lpad('4',2,0) ie_identificador  
union all

select 'SER_MED' nm_tabela, 'SERVICE' nm_atributo, lpad('5',2,0) ie_identificador  
union all

select 'SER_MED' nm_tabela, 'ZUSATZINFO' nm_atributo, lpad('6',2,0) ie_identificador  
union all

select 'AUS_MED' nm_tabela, 'KEY_AUS' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'AUS_MED' nm_tabela, 'PREISLINIE' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'GWVO_MED' nm_tabela, 'KEY_GWVO' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'GWVO_MED' nm_tabela, 'GDAT_INAKTIVIERUNG' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'GWVO_MED' nm_tabela, 'NAME' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'KLB_MED' nm_tabela, 'PZN' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'KLB_MED' nm_tabela, 'EINHEIT' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'KLB_MED' nm_tabela, 'KEY_ADA_ANBIETER' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'KLB_MED' nm_tabela, 'KEY_DAA' nm_atributo, lpad('4',2,0) ie_identificador  
union all

select 'KLB_MED' nm_tabela, 'KURZNAME' nm_atributo, lpad('5',2,0) ie_identificador  
union all

select 'KLB_MED' nm_tabela, 'MENGE' nm_atributo, lpad('6',2,0) ie_identificador  
union all

select 'KLB_MED' nm_tabela, 'VERKEHRSSTATUS' nm_atributo, lpad('7',2,0) ie_identificador  
union all

select 'KLB_MED' nm_tabela, 'VERTRIEBSSTATUS' nm_atributo, lpad('8',2,0) ie_identificador  
union all

select 'VAK_MED' nm_tabela, 'PZN_KLINIKPACKUNG' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'VAK_MED' nm_tabela, 'PZN_KLINIKBAUSTEIN' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'VAI_MED' nm_tabela, 'PZN' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'VAI_MED' nm_tabela, 'KEY_INB' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'INB_MED' nm_tabela, 'KEY_INB' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'INB_MED' nm_tabela, 'BESCHREIBUNG' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'DAA_MED' nm_tabela, 'KEY_DAA' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'DAA_MED' nm_tabela, 'NAME' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'DAA_MED' nm_tabela, 'ABKUERZUNG' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'AZG_MED' nm_tabela, 'KEY_GRU' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'AZG_MED' nm_tabela, 'PZN' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'GRU_MED' nm_tabela, 'KEY_GRU' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'GRU_MED' nm_tabela, 'MEHRKOSTENVERZICHT' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'GRU_MED' nm_tabela, 'VORRANG_AUT_IDEM' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'GRU_MED' nm_tabela, 'ZUZAHLUNGSFAKTOR' nm_atributo, lpad('4',2,0) ie_identificador  
union all

select 'IZG_MED' nm_tabela, 'KEY_GRU' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'IZG_MED' nm_tabela, 'IK' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'IKZ_MED' nm_tabela, 'IK' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'IKZ_MED' nm_tabela, 'NAME' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'ISA_MED' nm_tabela, 'PZN' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'ISA_MED' nm_tabela, 'IK' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'ISA_MED' nm_tabela, 'REGIONALKZ' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'VAV_MED' nm_tabela, 'PZN' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'VAV_MED' nm_tabela, 'KEY_VOV' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'VAV_MED' nm_tabela, 'BEFRISTUNGSDATUM' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'VOV_MED' nm_tabela, 'KEY_VOV' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'VOV_MED' nm_tabela, 'KEY_DOK' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'VOV_MED' nm_tabela, 'TEXT' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'VOV_MED' nm_tabela, 'TYP' nm_atributo, lpad('4',2,0) ie_identificador  
union all

select 'DOK_MED' nm_tabela, 'KEY_DOK' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'DOK_MED' nm_tabela, 'DATEIENDUNG' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'DOK_MED' nm_tabela, 'DOKUMENT' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'DOK_MED' nm_tabela, 'DOKUMENTTITEL' nm_atributo, lpad('4',2,0) ie_identificador  
union all

select 'DOK_MED' nm_tabela, 'ERLAEUTERUNG' nm_atributo, lpad('5',2,0) ie_identificador  
union all

select 'DOK_MED' nm_tabela, 'STAND' nm_atributo, lpad('6',2,0) ie_identificador  
union all

select 'PGR_MED' nm_tabela, 'PZN' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'PGR_MED' nm_tabela, 'PACKUNGSKOMPONENTE' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'PGR_MED' nm_tabela, 'EINSTUFUNG' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'PGR2_MED' nm_tabela, 'PZN' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'PGR2_MED' nm_tabela, 'ZAEHLER' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'PGR2_MED' nm_tabela, 'EINHEIT' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'PGR2_MED' nm_tabela, 'KOMPONENTENNR' nm_atributo, lpad('4',2,0) ie_identificador  
union all

select 'PGR2_MED' nm_tabela, 'TYP' nm_atributo, lpad('5',2,0) ie_identificador  
union all

select 'PGR2_MED' nm_tabela, 'ZAHL' nm_atributo, lpad('6',2,0) ie_identificador  
union all

select 'WAR_MED' nm_tabela, 'KEY_WAR' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'WAR_MED' nm_tabela, 'KEY_WAR_VERWEIS' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'WAR_MED' nm_tabela, 'NAME' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'PZN' nm_atributo, lpad('01',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'AM_MIT_ERSTATT_130B' nm_atributo, lpad('C1',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'AMPREISV_AMG' nm_atributo, lpad('07',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'AMPREISV_SGB' nm_atributo, lpad('76',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'APO_EK' nm_atributo, lpad('02',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'APO_EK_PPU' nm_atributo, lpad('C3',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'APO_VK' nm_atributo, lpad('04',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'APO_VK_PPU' nm_atributo, lpad('C4',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'APOPFLICHT' nm_atributo, lpad('03',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'APU' nm_atributo, lpad('14',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'APU_78_3A_1_AMG' nm_atributo, lpad('C0',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'APU_MIT_ABZUG_130B' nm_atributo, lpad('B6',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'ARTIKELNR' nm_atributo, lpad('B4',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'ARTIKELTYP' nm_atributo, lpad('05',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'ARZNEIMITTEL' nm_atributo, lpad('06',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'AUSNAHME_ERSETZUNG' nm_atributo, lpad('B3',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'BEDINGTE_ERSTATT_FAM' nm_atributo, lpad('78',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'BIOTECH_AM' nm_atributo, lpad('C7',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'BIOTECH_FAM' nm_atributo, lpad('93',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'BIOZID' nm_atributo, lpad('95',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'BOPSTNR' nm_atributo, lpad('C6',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'BTM' nm_atributo, lpad('08',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'DIAETETIKUM' nm_atributo, lpad('89',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'DIFF_PPU_APU_78_3A_1' nm_atributo, lpad('C5',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'DROGE_CHEMIKALIE' nm_atributo, lpad('46',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'ELEKTROSTOFFV' nm_atributo, lpad('B8',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'EU_BIO_LOGO' nm_atributo, lpad('A8',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'EXPLOSIVGRUNDSTOFF' nm_atributo, lpad('C8',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'FESTBETRAG' nm_atributo, lpad('12',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'FESTBETRAGSSTUFE' nm_atributo, lpad('13',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'GDAT_PREISE' nm_atributo, lpad('17',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'GDAT_VERKEHRSSTATUS' nm_atributo, lpad('15',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'GDAT_VERTRIEBSSTATUS' nm_atributo, lpad('16',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'GENERIKUM' nm_atributo, lpad('92',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'GTIN' nm_atributo, lpad('B5',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'HM_ZUM_VERBRAUCH' nm_atributo, lpad('77',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'IMPORT_REIMPORT' nm_atributo, lpad('18',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'KEY_ADA_ANBIETER' nm_atributo, lpad('31',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'KEY_ADA_HERSTELLER' nm_atributo, lpad('44',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'KEY_AUS' nm_atributo, lpad('45',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'KEY_DAA' nm_atributo, lpad('32',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'KEY_FES' nm_atributo, lpad('33',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'KEY_GWVO' nm_atributo, lpad('B2',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'KEY_WAR' nm_atributo, lpad('A7',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'KOSMETIKUM_EG_VO' nm_atributo, lpad('A9',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'KUEHLKETTE' nm_atributo, lpad('19',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'KURZNAME' nm_atributo, lpad('20',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'LAGERTEMPERATUR_MAX' nm_atributo, lpad('21',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'LAGERTEMPERATUR_MIN' nm_atributo, lpad('22',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'LANGNAME' nm_atributo, lpad('23',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'LANGNAME_UNGEKUERZT' nm_atributo, lpad('43',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'LAUFZEIT_VERFALL' nm_atributo, lpad('24',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'LEBENSMITTEL' nm_atributo, lpad('90',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'LIFESTYLE' nm_atributo, lpad('81',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'MEDIZINPRODUKT' nm_atributo, lpad('25',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'MITTEILUNG_47_1CAMG' nm_atributo, lpad('94',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'MWST' nm_atributo, lpad('26',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'NEGATIVLISTE' nm_atributo, lpad('29',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'NEM' nm_atributo, lpad('91',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'PFLANZENSCHUTZMITTEL' nm_atributo, lpad('96',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'POSITIONSNR' nm_atributo, lpad('30',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'PPU' nm_atributo, lpad('C2',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'PZN_KLEINERE_PACKUNG' nm_atributo, lpad('41',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'PZN_NACHFOLGER' nm_atributo, lpad('40',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'PZN_ORIGINAL' nm_atributo, lpad('42',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'RAB_APO' nm_atributo, lpad('72',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'RABWERT_130A_2_SGB' nm_atributo, lpad('A0',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'RABWERT_130B_SGB' nm_atributo, lpad('99',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'RABWERT_ANBIETER' nm_atributo, lpad('74',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'RABWERT_GENERIKUM' nm_atributo, lpad('85',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'RABWERT_PREISMORA' nm_atributo, lpad('86',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'REZEPTPFLICHT' nm_atributo, lpad('38',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'SORTIERBEGRIFF' nm_atributo, lpad('34',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'STERIL' nm_atributo, lpad('B1',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'TFG' nm_atributo, lpad('35',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'TIERARZNEIMITTEL' nm_atributo, lpad('47',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'T_REZEPT' nm_atributo, lpad('A2',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'UVP' nm_atributo, lpad('B0',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'VERFALLDATUM' nm_atributo, lpad('36',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'VERKEHRSSTATUS' nm_atributo, lpad('37',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'VERTRIEBSSTATUS' nm_atributo, lpad('39',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'VW_APO' nm_atributo, lpad('48',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'VW_GROSSHANDEL' nm_atributo, lpad('49',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'VW_KRANKENHAUSAPO' nm_atributo, lpad('50',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'VW_SONSTEINZELHANDEL' nm_atributo, lpad('51',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'WIRKSTOFF_EG_RL' nm_atributo, lpad('B7',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'ZUZFREI_31SGB_FEB' nm_atributo, lpad('88',2,0) ie_identificador  
union all

select 'ART_MED' nm_tabela, 'ZUZFREI_31SGB_TSTR' nm_atributo, lpad('80',2,0) ie_identificador  
union all

select 'KVP_MED' nm_tabela, 'KEY_KVP' nm_atributo, lpad('1',2,0) ie_identificador  
union all

select 'KVP_MED' nm_tabela, 'DATEINR' nm_atributo, lpad('2',2,0) ie_identificador  
union all

select 'KVP_MED' nm_tabela, 'ENTSCHLUESSELUNG' nm_atributo, lpad('3',2,0) ie_identificador  
union all

select 'KVP_MED' nm_tabela, 'ERLAEUTERUNG' nm_atributo, lpad('4',2,0) ie_identificador  
union all

select 'KVP_MED' nm_tabela, 'FELDIDENTIFIER' nm_atributo, lpad('5',2,0) ie_identificador  
union all

select 'KVP_MED' nm_tabela, 'INAKTIVIERUNGSDATUM' nm_atributo, lpad('6',2,0) ie_identificador  
union all

select 'KVP_MED' nm_tabela, 'INTERNE_NOTIZ' nm_atributo, lpad('7',2,0) ie_identificador  
union all

select 'KVP_MED' nm_tabela, 'PLURAL' nm_atributo, lpad('8',2,0) ie_identificador  
union all

select 'KVP_MED' nm_tabela, 'SCHLUESSELWERT' nm_atributo, lpad('9',2,0) ie_identificador;

