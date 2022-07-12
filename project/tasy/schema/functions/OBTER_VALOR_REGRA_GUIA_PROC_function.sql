-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_regra_guia_proc (nr_interno_conta_p bigint, cd_procedimento_p bigint, cd_autorizacao_p text) RETURNS bigint AS $body$
DECLARE


cd_procedimento_w 	bigint;
vl_retorno_w		double precision;
ie_verifica_w		varchar(20);
ie_resultado_w		varchar(20);
vl_procedimento_w	double precision;
vl_total_w		double precision;

C01 CURSOR FOR
	SELECT	cd_procedimento,
		vl_procedimento
	from	procedimento_paciente
	where	nr_interno_conta = nr_interno_conta_p
	and 	nr_doc_convenio = cd_autorizacao_p;


BEGIN

vl_retorno_w:= 0;
ie_verifica_w:= '';
ie_resultado_w:='';


/* Regra 1 */

OPEN C01;

LOOP
FETCH C01 into
	cd_procedimento_w,
	vl_procedimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	/*  Regra 1 - Interface Unimed Litoral (o Valor do procedimento 28011511 não deve somar no arquivo) */

	if	cd_procedimento_w = 28011511	then
		ie_verifica_w:=  ie_verifica_w || 'Y';
		vl_total_w   :=  vl_procedimento_w;
	end if;
	end;
END LOOP;
CLOSE C01;

if	position('Y'  upper(ie_verifica_w)) > 0 then
	ie_resultado_w:= ie_resultado_w || 'Y';
end if;

if (upper(ie_resultado_w) = 'Y') and (cd_procedimento_p = 28011511) then
	vl_retorno_w:= vl_retorno_w + vl_total_w;
end if;


/* Regra  2 */

ie_verifica_w := '';
ie_resultado_w:= '';

OPEN C01;

LOOP
FETCH C01 into
	cd_procedimento_w,
	vl_procedimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	/*  Regra 2 - Interface Unimed Litoral (O procedimento 28011520 não deve somar no arquivo) */

	if	cd_procedimento_w = 28011520	then
		ie_verifica_w:=  ie_verifica_w || 'C';
		vl_total_w   :=  vl_procedimento_w;
	end if;
	end;
END LOOP;
CLOSE C01;

if	position('C' in upper(ie_verifica_w)) > 0 then
	ie_resultado_w:= ie_resultado_w || 'C';
end if;

if (upper(ie_resultado_w) = 'C') and (cd_procedimento_p = 28011520) then
	vl_retorno_w:= vl_retorno_w + vl_total_w;
end if;


/* Regra 3 */

ie_verifica_w := '';
ie_resultado_w:= '';

OPEN C01;

LOOP
FETCH C01 into
	cd_procedimento_w,
	vl_procedimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	/*  Regra 3 - Interface Unimed Litoral (28100093,28100581) */

	if	cd_procedimento_w = 28100093	then
		ie_verifica_w:=  ie_verifica_w || 'D';
	end if;
	if	cd_procedimento_w = 28100581	then
		ie_verifica_w:=  ie_verifica_w || 'E';
		vl_total_w   :=  vl_procedimento_w;
	end if;
	end;
END LOOP;
CLOSE C01;


if	position('D' in upper(ie_verifica_w)) > 0 then
	ie_resultado_w:= ie_resultado_w || 'D';
end if;
if	position('E' in upper(ie_verifica_w)) > 0 then
	ie_resultado_w:= ie_resultado_w || 'E';
end if;

if (upper(ie_resultado_w) = 'DE') and (cd_procedimento_p = 28100581) then
	vl_retorno_w:= vl_retorno_w + vl_total_w;
end if;


/* Regra 4 */

ie_verifica_w := '';
ie_resultado_w:= '';

OPEN C01;

LOOP
FETCH C01 into
	cd_procedimento_w,
	vl_procedimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	/*  Regra 4 - Interface Unimed Litoral (28100549,28100034) */

	if	cd_procedimento_w = 28100549	then
		ie_verifica_w:=  ie_verifica_w || 'X';
	end if;
	if	cd_procedimento_w = 28100034	then
		ie_verifica_w:=  ie_verifica_w || 'Y';
		vl_total_w   :=  vl_procedimento_w;
	end if;
	end;
END LOOP;
CLOSE C01;


if	position('X' in upper(ie_verifica_w)) > 0 then
	ie_resultado_w:= ie_resultado_w || 'X';
end if;
if	position('Y' in upper(ie_verifica_w)) > 0 then
	ie_resultado_w:= ie_resultado_w || 'Y';
end if;

if (upper(ie_resultado_w) = 'XY') and (cd_procedimento_p = 28100034) then
	vl_retorno_w:= vl_retorno_w + vl_total_w;
end if;


Return	vl_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_regra_guia_proc (nr_interno_conta_p bigint, cd_procedimento_p bigint, cd_autorizacao_p text) FROM PUBLIC;
