-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_ordem_aprovar_reprovar_ccb ( nr_sequencia_p bigint, ie_status_p text, ds_motivo_p text, nm_usuario_p text) AS $body$
DECLARE


ie_generation_day_w		varchar(1);
qt_reg_w			bigint;
qt_aprovadores_pendent_w	bigint;
nr_seq_equipe_w			bigint;
nr_seq_ordem_serv_w		bigint;
nr_seq_impacto_w		bigint;


BEGIN

select	max(nr_seq_ordem_serv),
	max(nr_seq_equipe),
	max(nr_seq_impacto)
into STRICT	nr_seq_ordem_serv_w,
	nr_seq_equipe_w,
	nr_seq_impacto_w
from	man_ordem_serv_aprov_ccb
where	nr_sequencia = nr_sequencia_p;

if (ie_status_p = 'A') then
	begin
	select	count(1)
	into STRICT	qt_aprovadores_pendent_w
	from	man_ordem_serv_aprov_ccb a
	where	a.nr_seq_ordem_serv = nr_seq_ordem_serv_w
	and	coalesce(a.dt_aprovacao::text, '') = ''
	and 	a.nr_seq_impacto = nr_seq_impacto_w;
	
	select	coalesce(max('S'),'N')
	into STRICT	ie_generation_day_w
	from	version_merge vm
	where	trunc(vm.dt_version_generated) = trunc(clock_timestamp());

	if (ie_generation_day_w = 'S' and qt_aprovadores_pendent_w = 1) then
		begin
		select	count(1)
		into STRICT	qt_reg_w
		from	man_ordem_serv_imp_pr
		where	nr_seq_impacto = nr_seq_impacto_w
		and	ie_impacto_requisito in ('I', 'A', 'E');
	
		if (qt_reg_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1028861);
		end if;
		end;
	end if;
	
	update	man_ordem_serv_aprov_ccb
	set	ie_status = 'A',
		dt_aprovacao = clock_timestamp(),
		nm_usuario_aprov = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_sequencia_p;
	end;
elsif (ie_status_p = 'R') then

	update	man_ordem_serv_aprov_ccb
	set	ie_status = 'R',
		dt_reprovacao = clock_timestamp(),
		dt_aprovacao  = NULL,
		nm_usuario_aprov  = NULL,
		nm_usuario_reprov = nm_usuario_p,
		ds_motivo_reprov = ds_motivo_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia = nr_sequencia_p;

end if;

delete from man_ordem_servico_exec e
where	e.nr_seq_ordem = nr_seq_ordem_serv_w
and	e.nm_usuario_exec <> nm_usuario_p
and	e.nr_seq_tipo_exec = (SELECT nr_seq_tipo_exec from ccb_equipe ccbe where ccbe.nr_sequencia = nr_seq_equipe_w)
and	e.nm_usuario_exec in (select nm_usuario from usuario_equipe_ccb_v v where v.nr_seq_equipe = nr_seq_equipe_w)
and	not exists (
				SELECT	v.nm_usuario
				from	usuario_equipe_ccb_v v
				where	v.nr_seq_equipe <> nr_seq_equipe_w
				and	v.nm_usuario = e.nm_usuario_exec
			);

select	count(1)
into STRICT	qt_reg_w
from	man_ordem_serv_aprov_ccb
where	nr_seq_impacto	= nr_seq_impacto_w
and	ie_status in ('P');

if (qt_reg_w = 0 or ie_status_p = 'R') then
	CALL man_aprov_analise_impacto(nr_seq_impacto_w,nm_usuario_p);
end if;

commit;

/* Disparar email para os usuarios quando o CCB e cancelado. */

select	count(1)
into STRICT	qt_reg_w
from	man_ordem_serv_aprov_ccb
where	nr_sequencia = nr_sequencia_p
and	ie_status = 'R';

if (qt_reg_w > 0) then
	CALL avisar_aprovacao_ccb(nr_seq_impacto_w, 'R');
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_ordem_aprovar_reprovar_ccb ( nr_sequencia_p bigint, ie_status_p text, ds_motivo_p text, nm_usuario_p text) FROM PUBLIC;

