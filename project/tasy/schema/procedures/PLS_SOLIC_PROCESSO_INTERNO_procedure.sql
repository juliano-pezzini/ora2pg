-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_solic_processo_interno ( nr_seq_analise_p bigint, nr_seq_proc_interno_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_processo_interno_w		varchar(255);
nr_seq_requisicao_w		bigint;
nr_seq_guia_w			bigint;
nr_seq_execucao_w		bigint;
nr_seq_grupo_atual_w		bigint;
nr_seq_grupo_auditor_w		bigint;


BEGIN

update	pls_auditoria
set	ie_status		= 'AP',
	nr_seq_proc_interno	= nr_seq_proc_interno_p,
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_sequencia		= nr_seq_analise_p;

begin
	select	nr_seq_requisicao,
		nr_seq_guia,
		nr_seq_execucao
	into STRICT	nr_seq_requisicao_w,
		nr_seq_guia_w,
		nr_seq_execucao_w
	from	pls_auditoria
	where	nr_sequencia	= nr_seq_analise_p;
exception
when others then
	nr_seq_requisicao_w	:= 0;
	nr_seq_guia_w		:= 0;
	nr_seq_execucao_w	:= 0;
end;

begin
	select	substr(ds_processo_interno,1,255)
	into STRICT	ds_processo_interno_w
	from	pls_analise_proc_interno
	where	nr_sequencia	= nr_seq_proc_interno_p;
exception
when others then
	ds_processo_interno_w	:= 'X';
end;

select	pls_obter_grupo_analise_atual(nr_seq_analise_p)
into STRICT	nr_seq_grupo_atual_w
;

select	max(nr_seq_grupo)
into STRICT	nr_seq_grupo_auditor_w
from	pls_auditoria_grupo
where	nr_sequencia = nr_seq_grupo_atual_w;

if (coalesce(ds_processo_interno_w,'X')	<> 'X') then
	if (coalesce(nr_seq_requisicao_w,0)	<> 0) then
		CALL pls_req_gravar_hist_analise(	nr_seq_requisicao_w, nr_seq_grupo_auditor_w, 'L', 'O usuário '||nm_usuario_p||' solicitou o processo interno '||ds_processo_interno_w||
						' em '||to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss'), null, nm_usuario_p);
	elsif (coalesce(nr_seq_guia_w,0)	<> 0) then
		CALL pls_guia_gravar_hist_analise(	nr_seq_guia_w, nr_seq_grupo_auditor_w, 2, 'O usuário '||nm_usuario_p||' solicitou o processo interno '||ds_processo_interno_w||
						' em '||to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss'), null, nm_usuario_p);
	elsif (coalesce(nr_seq_execucao_w,0)	<> 0) then
		select	max(nr_seq_requisicao)
		into STRICT	nr_seq_requisicao_w
		from	pls_execucao_requisicao
		where	nr_sequencia	= nr_seq_execucao_w;

		if (coalesce(nr_seq_requisicao_w,0)	<> 0) then
			CALL pls_req_gravar_hist_analise(	nr_seq_requisicao_w, nr_seq_grupo_auditor_w, 'L', 'O usuário '||nm_usuario_p||' solicitou o processo interno '||ds_processo_interno_w||
							' em '||to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss'), nr_seq_execucao_w, nm_usuario_p);
		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_solic_processo_interno ( nr_seq_analise_p bigint, nr_seq_proc_interno_p bigint, nm_usuario_p text) FROM PUBLIC;

