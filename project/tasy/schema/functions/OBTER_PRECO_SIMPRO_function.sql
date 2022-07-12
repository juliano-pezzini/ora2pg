-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_preco_simpro ( cd_simpro_p bigint) RETURNS bigint AS $body$
DECLARE


vl_preco_fabrica_w	double precision;
vl_preco_venda_w	double precision;
vl_preco_w		double precision;
ie_tipo_preco_w		varchar(01);
cd_estab_simpro_w	estabelecimento.cd_estabelecimento%type;


BEGIN
cd_estab_simpro_w := wheb_usuario_pck.get_cd_estabelecimento;

vl_preco_w		:= 0;

SELECT	coalesce(MAX(vl_preco_venda),0),
	coalesce(MAX(vl_preco_fabrica),0),
	coalesce(MAX(ie_tipo_preco),'X')
INTO STRICT	vl_preco_venda_w,
	vl_preco_fabrica_w,
	ie_tipo_preco_w
FROM	simpro_preco
WHERE	cd_simpro = cd_simpro_p
AND	coalesce(cd_estabelecimento, coalesce(cd_estab_simpro_w, 0))	= coalesce(cd_estab_simpro_w, 0)
AND	dt_vigencia = (
	SELECT	MAX(dt_vigencia)
	FROM	simpro_preco
	WHERE	cd_simpro = cd_simpro_p
	AND	coalesce(cd_estabelecimento, coalesce(cd_estab_simpro_w, 0))	= coalesce(cd_estab_simpro_w, 0)
	AND	dt_vigencia <= clock_timestamp());

IF (ie_tipo_preco_w = 'V') THEN
	vl_preco_w	:= vl_preco_venda_w;
ELSIF (ie_tipo_preco_w = 'F') THEN
	vl_preco_w	:= vl_preco_fabrica_w;
END IF;

RETURN vl_preco_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_preco_simpro ( cd_simpro_p bigint) FROM PUBLIC;

