-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION wheb_exportar_hl7_long_pck.remover_quebra (ds_valor_p text) RETURNS text AS $body$
DECLARE

  ds_valor_w text;
  qt_controle_chr_w bigint;

BEGIN
    ds_valor_w := ds_valor_p;

    qt_controle_chr_w := 0;

	  while( position(chr(13) in ds_valor_w) > 0 ) and ( qt_controle_chr_w < 100 ) loop
		  ds_valor_w := replace(ds_valor_w,chr(13),'');
		  qt_controle_chr_w := qt_controle_chr_w + 1;
	  end loop;

	  qt_controle_chr_w := 0;

	  while( position(chr(10) in ds_valor_w) > 0 ) and ( qt_controle_chr_w < 100 ) loop
	  	ds_valor_w := replace(ds_valor_w,chr(10),'');
		  qt_controle_chr_w := qt_controle_chr_w + 1;
	  end loop;

    return ds_valor_w;
  end;

$body$
LANGUAGE PLPGSQL
 STABLE;
-- REVOKE ALL ON FUNCTION wheb_exportar_hl7_long_pck.remover_quebra (ds_valor_p text) FROM PUBLIC;
