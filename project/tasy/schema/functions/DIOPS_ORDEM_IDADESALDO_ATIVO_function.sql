-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION diops_ordem_idadesaldo_ativo ( ie_tipo_vencimento_p text) RETURNS bigint AS $body$
DECLARE


nr_ordem_w			smallint;


BEGIN

if (ie_tipo_vencimento_p	= '00') then
	nr_ordem_w		:= 1;
elsif (ie_tipo_vencimento_p	= '30') then
	nr_ordem_w		:= 2;
elsif (ie_tipo_vencimento_p	= '60') then
	nr_ordem_w		:= 3;
elsif (ie_tipo_vencimento_p	= '90') then
	nr_ordem_w		:= 4;
elsif (ie_tipo_vencimento_p	= '120') then
	nr_ordem_w		:= 5;
elsif (ie_tipo_vencimento_p	= '365') then
	nr_ordem_w		:= 6;
elsif (ie_tipo_vencimento_p	= '999') then
	nr_ordem_w		:= 7;
elsif (ie_tipo_vencimento_p	= '200') then
	nr_ordem_w		:= 8;
elsif (ie_tipo_vencimento_p	= '300') then
	nr_ordem_w		:= 9;
elsif (ie_tipo_vencimento_p	= '40') then
	nr_ordem_w		:= 10;
end if;

return	nr_ordem_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION diops_ordem_idadesaldo_ativo ( ie_tipo_vencimento_p text) FROM PUBLIC;
