-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_wells ( qt_score_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

  ds_retorno_w varchar(255);

BEGIN
 IF (ie_opcao_p       = 'P') THEN
	IF (qt_score_p    < 2) THEN
	  ds_retorno_w    := 1.3;
	elsif (qt_score_p >= 2) AND (qt_score_p <=6) THEN
	  ds_retorno_w    := 16.2;
	elsif (qt_score_p  > 6) THEN
	  ds_retorno_w    := 37.5;
	END IF;
  elsif (ie_opcao_p    = 'R') THEN
	IF (qt_score_p    <2) THEN
	  ds_retorno_w    := Wheb_mensagem_pck.get_texto(309772); --'Baixa';
	elsif (qt_score_p >= 2) AND (qt_score_p <=6) THEN
	  ds_retorno_w    := Wheb_mensagem_pck.get_texto(309773); --'Moderada';
	elsif (qt_score_p  > 6) THEN
	  ds_retorno_w    := Wheb_mensagem_pck.get_texto(1071230); --'Alta';
	END IF;
  END IF;
RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_wells ( qt_score_p bigint, ie_opcao_p text) FROM PUBLIC;

