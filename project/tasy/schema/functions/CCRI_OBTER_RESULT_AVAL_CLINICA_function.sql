-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ccri_obter_result_aval_clinica ( NR_SEQ_AVAL bigint) RETURNS varchar AS $body$
DECLARE

 
DS_RETORNO_W    varchar(4000);


BEGIN 
 
  Select CASE WHEN substr(Aval(nr_sequencia,1635),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1635),1,255)='S' THEN 'AAS(' END || 
      CASE WHEN substr(Aval(nr_sequencia,1635),1,255)='S' THEN substr(Aval(nr_sequencia,1592),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,1635),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1635),1,255)='S' THEN '), ' END ||    
      CASE WHEN substr(Aval(nr_sequencia,1638),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1638),1,255)='S' THEN 'AINE(' END || 
      CASE WHEN substr(Aval(nr_sequencia,1638),1,255)='S' THEN substr(Aval(nr_sequencia,2284),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,1638),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1638),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,2828),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,2828),1,255)='S' THEN 'Anticonvulsivante(' END || 
      CASE WHEN substr(Aval(nr_sequencia,2828),1,255)='S' THEN substr(Aval(nr_sequencia,2829),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,2828),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,2828),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,1641),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1641),1,255)='S' THEN 'Antidepressivo(' END || 
      CASE WHEN substr(Aval(nr_sequencia,1641),1,255)='S' THEN substr(Aval(nr_sequencia,2315),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,1641),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1641),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,1644),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1644),1,255)='S' THEN 'BCCa(' END || 
      CASE WHEN substr(Aval(nr_sequencia,1644),1,255)='S' THEN substr(Aval(nr_sequencia,2318),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,1644),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1644),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,1647),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1647),1,255)='S' THEN 'Betabloqueador(' END || 
      CASE WHEN substr(Aval(nr_sequencia,1647),1,255)='S' THEN substr(Aval(nr_sequencia,2321),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,1647),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1647),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,1650),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1650),1,255)='S' THEN 'BRA II(' END || 
      CASE WHEN substr(Aval(nr_sequencia,1650),1,255)='S' THEN substr(Aval(nr_sequencia,2324),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,1650),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1650),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,1652),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1652),1,255)='S' THEN 'Digitálico(' END || 
      CASE WHEN substr(Aval(nr_sequencia,1652),1,255)='S' THEN substr(Aval(nr_sequencia,2326),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,1652),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1652),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,1636),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1636),1,255)='S' THEN 'Diurético(' END || 
      CASE WHEN substr(Aval(nr_sequencia,1636),1,255)='S' THEN substr(Aval(nr_sequencia,2282),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,1636),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1636),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,1639),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1639),1,255)='S' THEN 'Estatina(' END || 
      CASE WHEN substr(Aval(nr_sequencia,1639),1,255)='S' THEN substr(Aval(nr_sequencia,2313),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,1639),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1639),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,1642),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1642),1,255)='S' THEN obter_desc_expressao(490503) || '(' END || -- Heparina 
      CASE WHEN substr(Aval(nr_sequencia,1642),1,255)='S' THEN substr(Aval(nr_sequencia,2316),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,1642),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1642),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,2830),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,2830),1,255)='S' THEN obter_desc_expressao(291299) || '(' END || -- Hipnóticos 
      CASE WHEN substr(Aval(nr_sequencia,2830),1,255)='S' THEN substr(Aval(nr_sequencia,2831),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,2830),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,2830),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,1645),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1645),1,255)='S' THEN 'Hipoglicemiante Oral(' END || 
      CASE WHEN substr(Aval(nr_sequencia,1645),1,255)='S' THEN substr(Aval(nr_sequencia,2319),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,1645),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1645),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,1648),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1648),1,255)='S' THEN obter_desc_expressao(344558) || '(' END || -- IECA 
      CASE WHEN substr(Aval(nr_sequencia,1648),1,255)='S' THEN substr(Aval(nr_sequencia,2335),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,1648),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1648),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,1651),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1651),1,255)='S' THEN 'IGPIIbIIIa(' END || 
      CASE WHEN substr(Aval(nr_sequencia,1651),1,255)='S' THEN substr(Aval(nr_sequencia,2325),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,1651),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1651),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,2832),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,2832),1,255)='S' THEN obter_desc_expressao(492845) || '(' END || -- Insulina 
      CASE WHEN substr(Aval(nr_sequencia,2832),1,255)='S' THEN substr(Aval(nr_sequencia,2833),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,2832),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,2832),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,1637),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1637),1,255)='S' THEN 'Metformina(' END || 
      CASE WHEN substr(Aval(nr_sequencia,1637),1,255)='S' THEN substr(Aval(nr_sequencia,2283),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,1637),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1637),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,1640),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1640),1,255)='S' THEN 'Nitrato(' END || 
      CASE WHEN substr(Aval(nr_sequencia,1640),1,255)='S' THEN substr(Aval(nr_sequencia,2314),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,1640),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1640),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,2834),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,2834),1,255)='S' THEN 'Ritmonorm(' END || 
      CASE WHEN substr(Aval(nr_sequencia,2834),1,255)='S' THEN substr(Aval(nr_sequencia,2836),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,2834),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,2834),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,1643),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1643),1,255)='S' THEN 'Sildenafil(' END || 
      CASE WHEN substr(Aval(nr_sequencia,1643),1,255)='S' THEN substr(Aval(nr_sequencia,2317),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,1643),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1643),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,2837),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,2837),1,255)='S' THEN 'Sotalol(' END || 
      CASE WHEN substr(Aval(nr_sequencia,2837),1,255)='S' THEN substr(Aval(nr_sequencia,2838),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,2837),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,2837),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,1646),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1646),1,255)='S' THEN 'Tienopiridínicos(' END || 
      CASE WHEN substr(Aval(nr_sequencia,1646),1,255)='S' THEN substr(Aval(nr_sequencia,2320),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,1646),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1646),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,1649),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1649),1,255)='S' THEN 'Warfarina(' END || 
      CASE WHEN substr(Aval(nr_sequencia,1649),1,255)='S' THEN substr(Aval(nr_sequencia,2323),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,1649),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1649),1,255)='S' THEN '), ' END || 
      CASE WHEN substr(Aval(nr_sequencia,1653),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1653),1,255)='S' THEN obter_desc_expressao(295064) || '(' END || -- Outros 
      CASE WHEN substr(Aval(nr_sequencia,1653),1,255)='S' THEN substr(Aval(nr_sequencia,2327),1,255) END || 
      CASE WHEN substr(Aval(nr_sequencia,1653),1,255) IS NULL THEN '' WHEN substr(Aval(nr_sequencia,1653),1,255)='S' THEN ')' END  resultado 
  into STRICT  DS_RETORNO_W 
  from  med_avaliacao_paciente where nr_sequencia = NR_SEQ_AVAL;
 
RETURN DS_RETORNO_W;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ccri_obter_result_aval_clinica ( NR_SEQ_AVAL bigint) FROM PUBLIC;

