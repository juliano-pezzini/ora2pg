-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_gravar_log_geracao_os_prev ( nr_seq_planej_prev_p bigint, nr_seq_equipamento_p bigint, nr_seq_ordem_serv_p bigint) AS $body$
DECLARE


nr_seq_ordem_serv_w		man_ordem_servico.nr_sequencia%type := coalesce(nr_seq_ordem_serv_p,0);
nr_seq_ult_os_prev_w		man_ordem_servico.nr_sequencia%type;
ie_data_inicio_geracao_w		man_planej_prev.ie_data_inicio_geracao%type;
ie_consid_prev_manual_w		varchar(255);


BEGIN
ie_consid_prev_manual_w := obter_param_usuario(298, 103, obter_perfil_ativo, coalesce(wheb_usuario_pck.get_nm_usuario,'Job'), wheb_usuario_pck.get_cd_estabelecimento, ie_consid_prev_manual_w);

if (coalesce(nr_seq_planej_prev_p,0) > 0) and (coalesce(nr_seq_equipamento_p,0) > 0) then
	begin

	begin
	select	ie_data_inicio_geracao
	into STRICT	ie_data_inicio_geracao_w
	from	man_planej_prev
	where	nr_sequencia = nr_seq_planej_prev_p;
	exception
	when others then
		null;
	end;

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_ult_os_prev_w
	from	man_ordem_servico
	where	nr_seq_equipamento = nr_seq_equipamento_p
	and	coalesce(nr_seq_planej,nr_seq_planej_prev_p) = nr_seq_planej_prev_p
	and	ie_tipo_ordem = 2
	and	nr_sequencia <> nr_seq_ordem_serv_w;

	if (coalesce(ie_data_inicio_geracao_w,'F') = 'P') and (coalesce(ie_consid_prev_manual_w,'N') = 'N') then
		begin
		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_ult_os_prev_w
		from	man_ordem_servico
		where	nr_seq_equipamento = nr_seq_equipamento_p
		and	nr_seq_planej = nr_seq_planej_prev_p
		and	ie_tipo_ordem = 2
		and	nr_sequencia <> nr_seq_ordem_serv_w;
		end;
	end if;

	insert into man_planej_prev_log(
			nr_sequencia,
			nr_seq_planej,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_equipamento,
			ie_status,
			nr_seq_ultima_prev,
			nr_seq_ordem_servico)
		values (	nextval('man_planej_prev_log_seq'),
			nr_seq_planej_prev_p,
			clock_timestamp(),
			'Tasy',
			clock_timestamp(),
			'Tasy',
			nr_seq_equipamento_p,
			CASE WHEN nr_seq_ordem_serv_w=0 THEN 'N'  ELSE 'G' END ,
			nr_seq_ult_os_prev_w,
			nr_seq_ordem_serv_w);

	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_gravar_log_geracao_os_prev ( nr_seq_planej_prev_p bigint, nr_seq_equipamento_p bigint, nr_seq_ordem_serv_p bigint) FROM PUBLIC;
