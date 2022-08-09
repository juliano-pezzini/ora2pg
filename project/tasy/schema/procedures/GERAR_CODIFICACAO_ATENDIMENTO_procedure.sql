-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_codificacao_atendimento ( nr_atendimento_p bigint, ie_clinica_p text, nm_usuario_p text, nr_seq_proc_pac_p bigint, cd_doenca_cid_p text, cd_procedimento_p bigint, ie_origem_proc_p bigint, ie_alta_p text, nr_cirurgia_p bigint default null) AS $body$
DECLARE


nr_sequencia_item_w			codificacao_atend_item.nr_sequencia%type;
nr_seq_codificacao_w		codificacao_atend_item.nr_seq_codificacao%type;
cd_doenca_cid_cod_w			codificacao_atend_item.cd_doenca_cid%type;
nr_seq_proc_interno_w		codificacao_atend_item.nr_seq_proc_interno%type;
nr_seq_interno_w			diagnostico_doenca.nr_seq_interno%type;
ie_classificacao_doenca_w	diagnostico_doenca.ie_classificacao_doenca%type;
cd_doenca_w					diagnostico_doenca.cd_doenca%type;
nr_seq_proc_w				procedimento_paciente.nr_sequencia%type;
cd_procedimento_w			procedimento_paciente.cd_procedimento%type;
cd_doenca_cid_w				procedimento_paciente.cd_doenca_cid%type;
ie_origem_proced_w			procedimento_paciente.ie_origem_proced%type;
cd_proc_vinculado_w			procedimento.cd_procimento_mx%type;
ie_existe_w					varchar(1);
cd_grupo_inicial_w			smallint := 0;
nr_sequencia_inicial_w		smallint := 0;
cd_grupo_aux_w				smallint := 0;
nr_sequencia_aux_w			smallint := 0;
cd_doenca_cid_aux_w			varchar(10);
cd_categ_cid_aux_w			varchar(10);
cd_espec_cid_aux_w			varchar(10);
cd_procedimento_aux_w		codificacao_regra_grupo.cd_procedimento%type;
ie_ajustar_grupo_w			varchar(1) := 'N';
ie_regra_cid_w				varchar(1) := 'N';
ie_regra_espec_w			varchar(1) := 'N';
ie_regra_categ_w			varchar(1) := 'N';
ie_regra_proced_w			varchar(1) := 'N';
ie_inserido_w				varchar(1) := 'N';

c01 CURSOR FOR
	SELECT	a.cd_doenca,
			a.nr_seq_interno,
			a.ie_classificacao_doenca
	from	diagnostico_doenca a
	where	nr_atendimento = nr_atendimento_p
	and 	not exists ( SELECT 	1
						from	codificacao_atend_item b
						where	a.nr_seq_interno = b.nr_seq_diag_pac)
	and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and		coalesce(dt_inativacao::text, '') = ''
	and		coalesce(ie_alta_p, 'N') = 'S';

c02 CURSOR FOR
	SELECT	a.nr_sequencia,
			a.cd_doenca_cid,
			a.cd_procedimento,
			a.ie_origem_proced
	from   	procedimento_paciente a
	where  	a.nr_atendimento = nr_atendimento_p
	and	   	codificacao_obter_regra(a.cd_procedimento, a.ie_origem_proced) > 0
	and 	coalesce(nr_cirurgia::text, '') = '';

c03 CURSOR FOR
	SELECT	distinct
			cd_doenca_cid,
			nr_seq_proc_interno
	from	codificacao_atend_item
	where 	nr_seq_codificacao = nr_seq_codificacao_w
	and		(cd_doenca_cid IS NOT NULL AND cd_doenca_cid::text <> '');

	procedure inserir_item_codificacao(	nr_seq_proc_pac_p		bigint,
					nr_seq_diag_pac_p		bigint,
					ie_tipo_item_p		text,
					cd_doenca_cid_p		text,
					nr_seq_proc_interno_p	bigint,
					ie_origem_proc_p		bigint,
					ie_classificacao_p		text,
					nr_cirurgia_p 		 bigint) is

	ie_existe_cirurgia_w	varchar(1) := 'N';
	
	
BEGIN
	
		select 	coalesce(max(nr_sequencia), 0) + 1
		into STRICT	nr_sequencia_item_w
		from	codificacao_atend_item
		where	nr_seq_codificacao = nr_seq_codificacao_w;

		if (ie_tipo_item_p = 'P') then

			select	max(cd_procedimento)
			into STRICT	cd_proc_vinculado_w
			from	cat_procedimento
			where	nr_sequencia = ( 	SELECT	max(cd_procimento_mx)
										from	procedimento
										where	cd_procedimento = nr_seq_proc_interno_p
										and		ie_origem_proced = ie_origem_proc_p);

		end if;

		if (nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') then

			select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
			into STRICT	ie_existe_cirurgia_w
			from	codificacao_atend_item
			where	nr_seq_codificacao = nr_seq_codificacao_w
			and		nr_cirurgia = nr_cirurgia_p;

		end if;

		if (ie_existe_cirurgia_w = 'N') then

			insert into codificacao_atend_item(
				nr_sequencia,
				nr_seq_codificacao,
				nr_seq_proc_pac,
				nr_seq_diag_pac,
				ie_tipo_item,
				cd_doenca_cid,
				nr_seq_proc_interno,
				ie_origem_proced,
				ie_classificacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nr_cirurgia
				)
			values (
				nr_sequencia_item_w,
				nr_seq_codificacao_w,
				nr_seq_proc_pac_p,
				nr_seq_diag_pac_p,
				ie_tipo_item_p,
				CASE WHEN ie_tipo_item_p='D' THEN  cd_doenca_cid_p  ELSE cd_proc_vinculado_w END ,
				nr_seq_proc_interno_p,
				ie_origem_proc_p,
				ie_classificacao_p,
				nm_usuario_p,
				clock_timestamp(),
				nr_cirurgia_p);

		end if;

	end;

begin

	select	max(nr_sequencia)
	into STRICT	nr_seq_codificacao_w
	from	codificacao_atendimento
	where	nr_atendimento = nr_atendimento_p;

	if (coalesce(nr_seq_codificacao_w::text, '') = '') then
		
	    select	nextval('codificacao_atendimento_seq')
		into STRICT	nr_seq_codificacao_w
		;

		insert into codificacao_atendimento(
			nr_sequencia,
			nr_atendimento,
			ie_tipo_clinica_ori,
			dt_atualizacao_nrec,
			nm_usuario_nrec)
		values (
			nr_seq_codificacao_w,
			nr_atendimento_p,
			ie_clinica_p,
			clock_timestamp(),
			nm_usuario_p);

			ie_ajustar_grupo_w := 'S';

	end if;

	select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
	into STRICT	ie_existe_w
	from	diagnostico_doenca
	where	nr_atendimento = nr_atendimento_p;

	if (ie_existe_w = 'S') then

		open C01;
		loop
		fetch C01 into
			cd_doenca_w,
			nr_seq_interno_w,
			ie_classificacao_doenca_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

			inserir_item_codificacao(null, nr_seq_interno_w, 'D', cd_doenca_w, null, null, null, nr_cirurgia_p);

		end;
		end loop;
		close C01;

	end if;

	if (nr_seq_proc_pac_p IS NOT NULL AND nr_seq_proc_pac_p::text <> '') or (nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') then

		select	CASE WHEN codificacao_obter_regra(cd_procedimento_p, ie_origem_proc_p, cd_doenca_cid_p)=0 THEN  'N'  ELSE 'S' END
		into STRICT	ie_existe_w
		;



		if (ie_existe_w = 'S') then
			inserir_item_codificacao(nr_seq_proc_pac_p, null, 'P', cd_doenca_cid_p, cd_procedimento_p, ie_origem_proc_p, null, nr_cirurgia_p);
		end if;

	else

		select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
		into STRICT	ie_existe_w
		from	procedimento_paciente
		where	nr_atendimento = nr_atendimento_p;

		if (ie_existe_w = 'S') then

			open C02;
			loop
			fetch C02 into
				nr_seq_interno_w,
				cd_doenca_cid_w,
				cd_procedimento_w,
				ie_origem_proced_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

				select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
				into STRICT	ie_inserido_w
				from	codificacao_atend_item
				where	nr_seq_codificacao = nr_seq_codificacao_w
				and		nr_seq_proc_interno = cd_procedimento_w;

				if (ie_inserido_w = 'N') then
					inserir_item_codificacao(nr_seq_interno_w, null, 'P', cd_doenca_cid_w, cd_procedimento_w, ie_origem_proced_w, null, nr_cirurgia_p);
				end if;

			end;
			end loop;
			close C02;

		end if;
	end if;

	if (ie_ajustar_grupo_w = 'S') then

		open c03;
		loop
		fetch c03 into
			cd_doenca_cid_cod_w,
			nr_seq_proc_interno_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
		begin

			select 	max(cg.nr_sequencia),
					max(cg.nr_ordem),
					max(cd_doenca_cid),
					max(cd_especialidade_cid),
					max(cd_categoria_cid),
					max(cd_procedimento)
			into STRICT	cd_grupo_aux_w,
					nr_sequencia_aux_w,
					cd_doenca_cid_aux_w,
					cd_espec_cid_aux_w,
					cd_categ_cid_aux_w,
					cd_procedimento_aux_w
			from	codificacao_grupo cg,
					codificacao_regra_grupo rg
			where	cg.nr_sequencia = rg.nr_seq_grupo
			and		((coalesce(rg.cd_procedimento::text, '') = '') or (rg.cd_procedimento = nr_seq_proc_interno_w))
			and		((coalesce(rg.cd_doenca_cid::text, '') = '' and coalesce(rg.cd_categoria_cid::text, '') = '' and coalesce(rg.cd_especialidade_cid::text, '') = '')
			or 		((rg.cd_doenca_cid = cd_doenca_cid_cod_w) or (obter_categoria_cid(cd_doenca_cid_cod_w) = rg.cd_categoria_cid) or (obter_especialidade_cid(cd_doenca_cid_cod_w) = rg.cd_especialidade_cid)))
			order by
					cd_doenca_cid asc,
					cg.nr_ordem desc LIMIT 1;

			if (cd_grupo_inicial_w = 0 and nr_sequencia_inicial_w = 0) then

				cd_grupo_inicial_w := cd_grupo_aux_w;
				nr_sequencia_inicial_w := nr_sequencia_aux_w;

				if (cd_doenca_cid_aux_w IS NOT NULL AND cd_doenca_cid_aux_w::text <> '') then
					ie_regra_cid_w := 'S';
				elsif (cd_espec_cid_aux_w IS NOT NULL AND cd_espec_cid_aux_w::text <> '') then
					ie_regra_espec_w := 'S';
				elsif (cd_categ_cid_aux_w IS NOT NULL AND cd_categ_cid_aux_w::text <> '') then
					ie_regra_categ_w := 'S';
				elsif (cd_procedimento_aux_w IS NOT NULL AND cd_procedimento_aux_w::text <> '') then
					ie_regra_proced_w := 'S';
				end if;

			elsif ((ie_regra_cid_w = 'N' and ie_regra_espec_w = 'N' and ie_regra_categ_w = 'N' and ie_regra_proced_w = 'N') and ((cd_doenca_cid_aux_w IS NOT NULL AND cd_doenca_cid_aux_w::text <> '') or (cd_espec_cid_aux_w IS NOT NULL AND cd_espec_cid_aux_w::text <> '') or (cd_categ_cid_aux_w IS NOT NULL AND cd_categ_cid_aux_w::text <> '') or (cd_procedimento_aux_w IS NOT NULL AND cd_procedimento_aux_w::text <> ''))) then

					cd_grupo_inicial_w := cd_grupo_aux_w;
					nr_sequencia_inicial_w := nr_sequencia_aux_w;

					if (cd_doenca_cid_aux_w IS NOT NULL AND cd_doenca_cid_aux_w::text <> '') then

						ie_regra_cid_w := 'S';
						ie_regra_espec_w := 'N';
						ie_regra_categ_w := 'N';
						ie_regra_proced_w := 'N';

					elsif (cd_espec_cid_aux_w IS NOT NULL AND cd_espec_cid_aux_w::text <> '') then

						ie_regra_cid_w := 'N';
						ie_regra_espec_w := 'S';
						ie_regra_categ_w := 'N';
						ie_regra_proced_w := 'N';

					elsif (cd_categ_cid_aux_w IS NOT NULL AND cd_categ_cid_aux_w::text <> '') then

						ie_regra_cid_w := 'N';
						ie_regra_espec_w := 'N';
						ie_regra_categ_w := 'S';
						ie_regra_proced_w := 'N';

					elsif (cd_procedimento_aux_w IS NOT NULL AND cd_procedimento_aux_w::text <> '') then

						ie_regra_cid_w := 'N';
						ie_regra_espec_w := 'N';
						ie_regra_categ_w := 'N';
						ie_regra_proced_w := 'S';

					end if;

			elsif ((ie_regra_proced_w = 'S') and (cd_procedimento_aux_w IS NOT NULL AND cd_procedimento_aux_w::text <> '') and (nr_sequencia_aux_w < nr_sequencia_inicial_w)) then

				cd_grupo_inicial_w := cd_grupo_aux_w;
				nr_sequencia_inicial_w := nr_sequencia_aux_w;

			elsif (ie_regra_cid_w = 'S' and (cd_doenca_cid_aux_w IS NOT NULL AND cd_doenca_cid_aux_w::text <> '')
				and nr_sequencia_aux_w < nr_sequencia_inicial_w) then

				cd_grupo_inicial_w := cd_grupo_aux_w;
				nr_sequencia_inicial_w := nr_sequencia_aux_w;

			elsif ((ie_regra_cid_w = 'N') and (ie_regra_espec_w = 'S' and (cd_espec_cid_aux_w IS NOT NULL AND cd_espec_cid_aux_w::text <> ''))	and (nr_sequencia_aux_w < nr_sequencia_inicial_w)) then

				cd_grupo_inicial_w := cd_grupo_aux_w;
				nr_sequencia_inicial_w := nr_sequencia_aux_w;

			elsif ((ie_regra_cid_w = 'N') and (ie_regra_espec_w = 'N') and (ie_regra_categ_w = 'S' and (cd_categ_cid_aux_w IS NOT NULL AND cd_categ_cid_aux_w::text <> ''))	and (nr_sequencia_aux_w < nr_sequencia_inicial_w)) then

				cd_grupo_inicial_w := cd_grupo_aux_w;
				nr_sequencia_inicial_w := nr_sequencia_aux_w;

			elsif ((ie_regra_cid_w = 'N' and ie_regra_espec_w = 'N' and cd_categ_cid_aux_w = 'N' and ie_regra_proced_w = 'N') and (coalesce(cd_doenca_cid_aux_w::text, '') = '' and coalesce(cd_espec_cid_aux_w::text, '') = '' and coalesce(cd_categ_cid_aux_w::text, '') = '' and coalesce(cd_procedimento_aux_w::text, '') = '') and (nr_sequencia_aux_w < nr_sequencia_inicial_w)) then

				cd_grupo_inicial_w := cd_grupo_aux_w;
				nr_sequencia_inicial_w := nr_sequencia_aux_w;

			end if;

		end;
		end loop;
		close c03;

		if (coalesce(cd_grupo_inicial_w::text, '') = '') then

			select 	min(nr_sequencia)
			into STRICT	cd_grupo_inicial_w
			from	codificacao_grupo
			where	nr_ordem = (SELECT min(nr_ordem) from codificacao_grupo);

		end if;

		if (cd_grupo_inicial_w > 0) then

			update	codificacao_atendimento
			set		cd_grupo_inicial = cd_grupo_inicial_w
			where	nr_sequencia = nr_seq_codificacao_w;

		end if;

	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_codificacao_atendimento ( nr_atendimento_p bigint, ie_clinica_p text, nm_usuario_p text, nr_seq_proc_pac_p bigint, cd_doenca_cid_p text, cd_procedimento_p bigint, ie_origem_proc_p bigint, ie_alta_p text, nr_cirurgia_p bigint default null) FROM PUBLIC;
