-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_ativ_real_pendente ( nr_seq_ordem_p bigint, nr_seq_ativ_p bigint, nm_usuario_exec_p text) RETURNS varchar AS $body$
DECLARE


ie_ativ_aberta_w	varchar(1);


BEGIN

ie_ativ_aberta_w	:= 'N';

if (nr_seq_ativ_p > 0) then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_ativ_aberta_w
	from	MAN_ORDEM_ATIV_PREV
	where	nr_seq_ordem_serv	= nr_seq_ordem_p
	and	nr_sequencia		= nr_seq_ativ_p
	and	NM_USUARIO_PREV		= nm_usuario_exec_p
	and	pr_atividade		= 100
	--and	DT_PREVISTA between trunc(sysdate) and fim_dia(sysdate)
	and	(dt_real IS NOT NULL AND dt_real::text <> '');
else
	ie_ativ_aberta_w	:= 'S';
end  if;

return ie_ativ_aberta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_ativ_real_pendente ( nr_seq_ordem_p bigint, nr_seq_ativ_p bigint, nm_usuario_exec_p text) FROM PUBLIC;

