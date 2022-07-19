-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vinc_os_nec_atlz_migr_proj_rev ( nr_seq_os_p bigint, cd_funcao_p bigint, qt_min_prev_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_ativ_funcao_w		bigint;
nr_seq_ativ_os_w		bigint;
nr_seq_apres_funcao_w		bigint;
nr_seq_apres_os_w		bigint;
nr_seq_vinc_proj_w		bigint;

nr_seq_projeto_w		bigint;
ie_tasymed_w			varchar(1);

cd_pessoa_programador_w		varchar(10);
nm_usuario_programador_w	varchar(15);

ie_existe_revisor_w		varchar(1) := 'N';

c01 CURSOR FOR
SELECT	coalesce(pp.cd_pessoa_fisica,'0')
from	proj_equipe_papel pp,
	proj_equipe pe
where	pp.nr_seq_equipe = pe.nr_sequencia
and	pp.nr_seq_funcao = 44
and	pp.ie_funcao_rec_migr = 'R'
and	pe.nr_seq_equipe_funcao = 11
and	coalesce(pp.ie_situacao,'A') = 'A'
and	pe.nr_seq_proj = nr_seq_projeto_w
order by
	pp.nr_seq_apres desc;


BEGIN
if (nr_seq_os_p IS NOT NULL AND nr_seq_os_p::text <> '') and (cd_funcao_p IS NOT NULL AND cd_funcao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	ie_tasymed_w := obter_se_funcao_tasymed(cd_funcao_p);

	if (ie_tasymed_w = 'N') then
		begin
		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_projeto_w
		from	proj_projeto
		where	cd_funcao = cd_funcao_p
		and	nr_seq_classif = 14;
		end;
	else
		begin
		nr_seq_projeto_w := 1644;
		end;
	end if;

	if (nr_seq_projeto_w > 0) then
		begin
		select	nextval('proj_ordem_servico_seq')
		into STRICT	nr_seq_vinc_proj_w
		;

		insert into proj_ordem_servico(
			nr_sequencia,
			nr_seq_proj,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_ordem,
			ie_tipo_ordem)
		values (
			nr_seq_vinc_proj_w,
			nr_seq_projeto_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_os_p,
			'R');

		/*begin
		ie_existe_revisor_w := 'N';
		open c01;
		loop
		fetch c01 into cd_pessoa_programador_w;
		exit when c01%notfound;
			begin
			ie_existe_revisor_w := 'S';
			if	(cd_pessoa_programador_w <> '0') then
				begin
				nm_usuario_programador_w := obter_usuario_pf(cd_pessoa_programador_w);
				if	(nm_usuario_programador_w is not null) then
					begin
					insert into man_ordem_servico_exec (
						nr_sequencia,
						nr_seq_ordem,
						dt_atualizacao,
						nm_usuario,
						nm_usuario_exec,
						qt_min_prev,
						dt_ult_visao,
						nr_seq_funcao,
						dt_recebimento,
						nr_seq_tipo_exec)
					values (
						man_ordem_servico_exec_seq.nextval,
						nr_seq_os_p,
						sysdate,
						'Tasy',
						nm_usuario_programador_w,
						null, --qt_min_prev_p,
						null,
						null,
						null,
						2);
					end;
				end if;
				end;
			end if;
			end;
		end loop;
		close c01;
		exception
		when others then
			cd_pessoa_programador_w := '';
			if	(ie_existe_revisor_w = 'N') then
				begin
				raise_application_error(-20011,'O projeto ' || to_char(nr_seq_projeto_w) || ' não possui um recurso definido para atendimento das ordens de revisão!#@#@');
				end;
			end if;
		end;*/
		end;
	end if;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vinc_os_nec_atlz_migr_proj_rev ( nr_seq_os_p bigint, cd_funcao_p bigint, qt_min_prev_p bigint, nm_usuario_p text) FROM PUBLIC;

