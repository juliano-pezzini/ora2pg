-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_conta_ctb_trans_fin ( nr_seq_trans_financ_p bigint, cd_conta_contabil_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(20);
qt_contas_w			smallint := 0;
qt_contas_trans_w		smallint := 0;


BEGIN

select	coalesce(count(*),0)
into STRICT	qt_contas_trans_w
from	trans_financ_conta_ctb
where	nr_seq_trans_financ 	= nr_seq_trans_financ_p
and	cd_conta_contabil	= cd_conta_contabil_p;

select	coalesce(count(*),0)
into STRICT	qt_contas_w
from	trans_financ_conta_ctb
where	nr_seq_trans_financ 	= nr_seq_trans_financ_p;

ds_retorno_w	:= 'N';

if	((coalesce(qt_contas_trans_w,0) > 0) or (coalesce(qt_contas_w,0) = 0)) then
	ds_retorno_w := 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_conta_ctb_trans_fin ( nr_seq_trans_financ_p bigint, cd_conta_contabil_p text) FROM PUBLIC;

