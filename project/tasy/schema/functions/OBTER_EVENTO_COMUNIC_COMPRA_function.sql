-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_evento_comunic_compra ( nr_sequencia_p bigint, cd_evento_p text) RETURNS varchar AS $body$
DECLARE


ie_permite_w		varchar(1);
cd_funcao_w		integer;

c01 CURSOR FOR
	SELECT	cd_funcao
	from	regra_envio_comunic_compra
	where	nr_sequencia = nr_sequencia_p;

BEGIN
ie_permite_w	:= 'N';
OPEN C01;
LOOP
FETCH C01 into
	cd_funcao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	if (ie_permite_w = 'N') then
		begin
		if (cd_funcao_w = 267) and (cd_evento_p in ('1','2','6','7','11','12','69','71')) then
			ie_permite_w	:= 'S';
		elsif (cd_funcao_w = 915) and (cd_evento_p in ('3','4','14','17','20','63','76','77','78')) then
			ie_permite_w	:= 'S';
		elsif (cd_funcao_w = 40) and (cd_evento_p in ('5','27','82','84')) then
			ie_permite_w	:= 'S';
		elsif (cd_funcao_w = 913) and (cd_evento_p in ('8', '9','10','15','16','28','47','52','57','72')) then
			ie_permite_w	:= 'S';
		elsif (cd_funcao_w = 6) and (cd_evento_p in ('18','19','23') )then
			ie_permite_w	:= 'S';
		elsif (cd_funcao_w = 917) and (cd_evento_p in ('13','21','22','25','35','37', '49', '51', '53','58','81')) then
			ie_permite_w	:= 'S';
		elsif (cd_funcao_w = 919) and (cd_evento_p in ('24','70')) then
			ie_permite_w	:= 'S';
		elsif (cd_funcao_w = 871) and (cd_evento_p in ('26','40','41','42','43','44','45','46','75')) then
			ie_permite_w	:= 'S';	
		elsif (cd_funcao_w = -124) and (cd_evento_p in ('29','50')) then
			ie_permite_w	:= 'S';	
		elsif (cd_funcao_w = 146) and (cd_evento_p in ('30','31','32','33','34')) then
			ie_permite_w	:= 'S';
		elsif (cd_funcao_w = 143) and (cd_evento_p in ('36','38','55','56','59','61','64')) then
			ie_permite_w	:= 'S';
		elsif (cd_funcao_w = 953) and (cd_evento_p in ('48','74')) then
			ie_permite_w	:= 'S';
		elsif (cd_funcao_w = 270) and (cd_evento_p in ('54','73')) then
			ie_permite_w	:= 'S';
		elsif (cd_funcao_w = 869) and (cd_evento_p in ('62','66')) then
			ie_permite_w	:= 'S';			
                elsif (cd_funcao_w = 109) and (cd_evento_p = 65) then
			ie_permite_w	:= 'S';
		elsif (cd_funcao_w = 981) and (cd_evento_p in (67,68)) then
			ie_permite_w	:= 'S';
		elsif (cd_funcao_w = 3006) and (cd_evento_p in ('79','80'))	then
			ie_permite_w	:= 'S';
		end if;
		end;
	end if;
end loop;
close c01;

return ie_permite_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_evento_comunic_compra ( nr_sequencia_p bigint, cd_evento_p text) FROM PUBLIC;

