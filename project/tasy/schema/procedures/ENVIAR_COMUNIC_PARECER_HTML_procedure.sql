-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_comunic_parecer_html ( nr_parecer_p bigint, ie_tipo_p bigint, cd_estabelecimento_p bigint, nr_seq_parecer_p bigint, nm_usuario_p text) AS $body$
DECLARE


nm_usuario_w			varchar(15);
nm_usuario_ww	 		varchar(15);
nm_destino_w			varchar(4000) := '';
nm_destino_ww			varchar(25) := '';
nm_usuario_cad_w		varchar(15) := '';
cd_especialidade_dest_w		integer;
cd_especialidade_dest_prof_w	integer;
nr_sequencia_w			bigint;
nr_sequencia_ww			bigint;
nr_atendimento_w		bigint;
nm_paciente_w			varchar(300);
nm_medico_w			varchar(100) := 0;
ds_parecer_w 			varchar(32000) := '';
ds_parecer_ww			varchar(32000) := '';
nr_seq_resultado_w		bigint;
ds_pos_inicio_rtf_w		bigint;
nm_medico_consultor_w		varchar(100);
cd_medico_parecer_w		bigint;
cd_pessoa_fisica_w		varchar(10);
nr_seq_equipe_w			bigint;
ds_seq_equipe_w			varchar(255);
ds_leito_w			varchar(255);
ds_especialidade_origem_w	varchar(255);
ds_especialidade_dest_w		varchar(255);
ds_setor_w	varchar(255);
ie_equipe_w	varchar(10);
ie_mostra_pedido_w		varchar(10);
ds_orient_parecer_med_w	varchar(4000) := '';
nr_seq_rtf_srtring_w			bigint;
ds_usuario_espec_w		varchar(255);
qt_reg_w				bigint;
ds_quebra_w 			varchar(10);

C01 CURSOR FOR
	SELECT	substr(obter_usuario_pf(cd_pessoa_fisica),1,100)
	from	medico_especialidade a
	where	obter_se_corpo_clinico(cd_pessoa_fisica) = 'S'
	and	cd_especialidade = cd_especialidade_dest_w
	and	substr(obter_usuario_pf(cd_pessoa_fisica),1,100) is not null
	and	coalesce(cd_medico_parecer_w::text, '') = ''
	and	coalesce(cd_especialidade_dest_prof_w,0) = 0
	and	exists (SELECT	1
			from medico x
			where	x.cd_pessoa_fisica = a.cd_pessoa_fisica
			and	x.ie_situacao = 'A')
	
union

	select	substr(obter_usuario_pf(cd_pessoa_fisica),1,100)
	from	profissional_especialidade
	where	cd_especialidade_prof = cd_especialidade_dest_prof_w
	and	substr(obter_usuario_pf(cd_pessoa_fisica),1,100) is not null
	and	coalesce(cd_medico_parecer_w::text, '') = ''
	and	coalesce(cd_especialidade_dest_w,0) = 0
	
union

	select	substr(obter_usuario_pf(cd_medico_parecer_w),1,100)
	
	where	(cd_medico_parecer_w IS NOT NULL AND cd_medico_parecer_w::text <> '')
	
union

	select  substr(obter_usuario_pf(b.cd_pessoa_fisica),1,100)
	from     pf_equipe_partic b,
		pf_equipe a
	where	a.nr_sequencia = b.nr_seq_equipe
	and	a.cd_pessoa_fisica	= cd_medico_parecer_w
	and	coalesce(a.ie_situacao,'A')  = 'A'
	and	(cd_medico_parecer_w IS NOT NULL AND cd_medico_parecer_w::text <> '')
	and	ie_equipe_w	= 'S'
	
union

	select  substr(obter_usuario_pf(b.cd_pessoa_fisica),1,100)
	from     pf_equipe_partic b,
		pf_equipe a
	where	a.nr_sequencia = b.nr_seq_equipe
	and	a.nr_sequencia	= nr_seq_equipe_w
	and	coalesce(a.ie_situacao,'A')  = 'A'
	and	(nr_seq_equipe_w IS NOT NULL AND nr_seq_equipe_w::text <> '')
	
union

	select  substr(obter_usuario_pf(a.cd_pessoa_fisica),1,100)
	from    pf_equipe a
	where	a.nr_sequencia	= nr_seq_equipe_w
	and	coalesce(a.ie_situacao,'A')  = 'A'
	and	(nr_seq_equipe_w IS NOT NULL AND nr_seq_equipe_w::text <> '')
	
union

	select	substr(obter_usuario_pf(b.cd_pessoa_fisica),1,100)
	from	espec_regra_parecer a,
		medico_especialidade b
	where	a.cd_especialidade_dest = b.cd_especialidade
	and	a.cd_especialidade = cd_especialidade_dest_w
	and	substr(obter_usuario_pf(b.cd_pessoa_fisica),1,100) is not null
	order by	1;


BEGIN
ds_usuario_espec_w := obter_param_usuario(281, 1375, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ds_usuario_espec_w);
ie_mostra_pedido_w := obter_param_usuario(281, 1377, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_mostra_pedido_w);

select	max(coalesce(cd_especialidade_dest,0)),
	max(coalesce(cd_especialidade_dest_prof,0)),
	max(nr_atendimento),
	max(obter_nome_pf(cd_pessoa_fisica)),
	max(cd_pessoa_parecer),
	max(cd_pessoa_fisica),
	max(nr_seq_equipe_dest),
	max(substr(OBTER_DESC_PF_EQUIPE(nr_seq_equipe_dest),1,150)),
	max(SUBSTR(Obter_Unidade_Atendimento(nr_atendimento,'A','S'),1,120)),
	max(substr(Obter_Unidade_Atendimento(nr_atendimento,'A','UB')||Obter_Unidade_Atendimento(nr_atendimento,'A','UC'),1,80)),
	max(CASE WHEN coalesce(cd_especialidade::text, '') = '' THEN Obter_Desc_Espec_Profissional(cd_especialidade_prof)  ELSE Obter_Desc_Espec_medica(cd_especialidade) END ),
	max(CASE WHEN coalesce(cd_especialidade::text, '') = '' THEN Obter_Desc_Espec_Profissional(cd_especialidade_dest_prof)  ELSE Obter_Desc_Espec_medica(cd_especialidade_dest) END )
into STRICT	cd_especialidade_dest_w,
	cd_especialidade_dest_prof_w,
	nr_atendimento_w,
	nm_paciente_w,
	cd_medico_parecer_w,
	cd_pessoa_fisica_w,
	nr_seq_equipe_w,
	ds_seq_equipe_w,
	ds_setor_w,
	ds_leito_w,
	ds_especialidade_origem_w,
	ds_especialidade_dest_w
from	parecer_medico_req
where	nr_parecer = nr_parecer_p;

select 	max(trim(both ds_orient_parecer_med))
into STRICT	ds_orient_parecer_med_w
from	parametro_medico
where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

ds_quebra_w := wheb_rtf_pck.get_quebra_linha;
if (nr_parecer_p IS NOT NULL AND nr_parecer_p::text <> '') then

	select	nextval('comunic_interna_seq')
	into STRICT	nr_sequencia_w
	;

	if (ie_tipo_p = 1) then

		select	obter_nome_medico(cd_medico,'N'),
			ds_motivo_consulta,
			substr(obter_usuario_pf(cd_medico),1,100)
		into STRICT	nm_medico_w,
			ds_parecer_w,
			nm_usuario_cad_w
		from	parecer_medico_req
		where	nr_parecer = nr_parecer_p;

		if (ds_parecer_w IS NOT NULL AND ds_parecer_w::text <> '') then
			/*Pega o cabecalho do RTF*/

			ds_pos_inicio_rtf_w := position('lang1046' in ds_parecer_w)+8;
			ds_parecer_ww 	:= substr(ds_parecer_w,1,ds_pos_inicio_rtf_w) || 'fs20 ';
			ds_parecer_ww	:= wheb_rtf_pck.get_cabecalho;

            if (ds_pos_inicio_rtf_w = 0) then
					begin
					nr_seq_rtf_srtring_w := converte_rtf_string(
					' SELECT DS_MOTIVO_CONSULTA
					   FROM PARECER_MEDICO_REQ
						WHERE NR_PARECER = :nr_parecer_p ', nr_parecer_p, nm_usuario_p, nr_seq_rtf_srtring_w);
					select	ds_texto
					into STRICT	ds_parecer_ww
					from	tasy_conversao_rtf
					where	nr_sequencia	= nr_seq_rtf_srtring_w;
					exception
					when others then
						ds_parecer_ww	:= '';
					end;
				end if;
			if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
				ds_parecer_ww := ds_parecer_ww ||
				wheb_mensagem_pck.get_texto(345021,'NR_ATENDIMENTO_W='||nr_atendimento_w)  || ds_quebra_w ||
				wheb_mensagem_pck.get_texto(344884,'NM_PACIENTE='||nm_paciente_w) || ds_quebra_w;
			else
				ds_parecer_ww := ds_parecer_ww ||
				wheb_mensagem_pck.get_texto(344881,'NM_PACIENTE_W='||nm_paciente_w) || ds_quebra_w;
			end if;

			ds_parecer_ww	:= ds_parecer_ww ||wheb_mensagem_pck.get_texto(344942,'SETORW='||ds_setor_w)|| ds_quebra_w;
			ds_parecer_ww	:= ds_parecer_ww ||wheb_mensagem_pck.get_texto(344946,'DS_LEITO_W='||ds_leito_w)|| ds_quebra_w;

			ds_parecer_ww	:= ds_parecer_ww ||wheb_mensagem_pck.get_texto(344981,'NM_MEDICO_W='||nm_medico_w)||ds_quebra_w;

			if (ds_especialidade_origem_w IS NOT NULL AND ds_especialidade_origem_w::text <> '') then
				ds_parecer_ww	:= ds_parecer_ww || wheb_mensagem_pck.get_texto(344982,'DS_ESPECIALIDADE_ORIGEM_W='||ds_especialidade_origem_w)|| ds_quebra_w;
			end if;
			if (ds_especialidade_dest_w IS NOT NULL AND ds_especialidade_dest_w::text <> '') then
				ds_parecer_ww	:= ds_parecer_ww ||wheb_mensagem_pck.get_texto(344985,'DS_ESPECIALIDADE_DEST_W='||ds_especialidade_dest_w)|| ds_quebra_w;
			end if;

			if (ds_seq_equipe_w IS NOT NULL AND ds_seq_equipe_w::text <> '') then
				ds_parecer_ww	:= ds_parecer_ww || wheb_mensagem_pck.get_texto(344990,'DS_SEQ_EQUIPE_W='||ds_seq_equipe_w) || ds_quebra_w;
			end if;

			if (ds_orient_parecer_med_w IS NOT NULL AND ds_orient_parecer_med_w::text <> '') then
					ds_parecer_ww	:= ds_parecer_ww ||replace(ds_orient_parecer_med_w,Chr(13),ds_quebra_w) || ds_quebra_w || ds_quebra_w;
			end if;

			if (ie_mostra_pedido_w = 'S') then
				ds_parecer_ww := ds_parecer_ww || wheb_mensagem_pck.get_texto(1013116) || ': \par \par '|| substr(ds_parecer_w, position(ds_pos_inicio_rtf_w in ds_pos_inicio_rtf_w),length(ds_parecer_w));
			else
				ds_parecer_ww := ds_parecer_ww || ds_quebra_w||ds_quebra_w;
			end if;

			ds_parecer_ww	:= ds_parecer_ww||wheb_rtf_pck.get_rodape;
		end if;

		if (nm_usuario_cad_w IS NOT NULL AND nm_usuario_cad_w::text <> '') then
			if (ds_usuario_espec_w = 'S') then

				select  count(*)
				into STRICT	qt_reg_w
				from    medico
				where   ie_retaguarda = 'S'
				and     nm_usuario = nm_usuario_cad_w;

				if (qt_reg_w > 0) then
					nm_destino_w := nm_usuario_cad_w|| ',';
				end if;

			else
				nm_destino_w := nm_usuario_cad_w || ',';
			end if;
		end if;

		ie_equipe_w := obter_param_usuario(281, 733, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_equipe_w);

		open C01;
		loop
		fetch C01 into
			nm_usuario_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			if (obter_se_estabelecido_usuario(nm_usuario_w, cd_estabelecimento_p ) = 'S') then
				begin
				if (ds_usuario_espec_w = 'S') and (obter_se_usuario_medico(nm_usuario_w) = 'S') then
					begin

					select  count(*)
					into STRICT	qt_reg_w
					from    medico
					where   ie_retaguarda = 'S'
					and     cd_pessoa_fisica = obter_pessoa_fisica_usuario(nm_usuario_w, 'C');

					if (qt_reg_w > 0) then
						nm_destino_w := nm_destino_w||nm_usuario_w|| ',';
					end if;

					end;
				else
					nm_destino_w := nm_destino_w || nm_usuario_w || ',';
				end if;
				end;
			end if;
			end;
		end loop;
		close C01;

		if (ds_parecer_ww IS NOT NULL AND ds_parecer_ww::text <> '') then

			insert	into comunic_interna(cd_estab_destino,
					nr_sequencia,
					ds_titulo,
					dt_comunicado,
					ds_comunicado,
					nm_usuario,
					nm_usuario_destino,
					dt_atualizacao,
					ie_geral,
					ie_gerencial,
					ds_perfil_adicional,
					dt_liberacao)
			values (
					cd_estabelecimento_p,
					nr_sequencia_w,
					wheb_mensagem_pck.get_texto(344994) || ' - '||nr_parecer_p,
					clock_timestamp(),
					ds_parecer_ww,
					nm_usuario_p,
					nm_destino_w,
					clock_timestamp(),
					'N',
					'N',
					null,
					clock_timestamp());

            begin
			nr_sequencia_ww := converte_rtf_html('select ds_comunicado from comunic_interna where nr_sequencia = :nr_sequencia_p', to_char(nr_sequencia_w), nm_usuario_p, nr_sequencia_ww);

			select	ds_texto
			into STRICT	ds_parecer_ww
			from	tasy_conversao_rtf
			where	nr_sequencia	= nr_sequencia_ww;
            exception
            when others then
                ds_parecer_ww	:= '';
            end;
			update comunic_interna set ds_comunicado = ds_parecer_ww where nr_sequencia = nr_sequencia_w;

		end if;

	end if;

	if (ie_tipo_p = 2) then

		select	obter_nome_medico(cd_medico,'N'),
			ds_parecer,
			substr(obter_usuario_pf(cd_medico),1,100)
		into STRICT	nm_medico_w,
			ds_parecer_w,
			nm_usuario_cad_w
		from	parecer_medico
		where	nr_sequencia	= nr_seq_parecer_p
		and	nr_parecer	= nr_parecer_p;

		if (ds_parecer_w IS NOT NULL AND ds_parecer_w::text <> '') then

			ds_pos_inicio_rtf_w := position('lang1046' in ds_parecer_w)+8;
			ds_parecer_ww 	:= substr(ds_parecer_w,1,ds_pos_inicio_rtf_w) || 'fs20 ';
			ds_parecer_ww	:= wheb_rtf_pck.get_cabecalho;

            if (ds_pos_inicio_rtf_w = 0) then
					begin
					nr_seq_rtf_srtring_w := converte_rtf_string(
					' SELECT ds_parecer
					   FROM parecer_medico
						WHERE NR_PARECER = :nr_parecer_p ', nr_parecer_p, nm_usuario_p, nr_seq_rtf_srtring_w);
					select	ds_texto
					into STRICT	ds_parecer_ww
					from	tasy_conversao_rtf
					where	nr_sequencia	= nr_seq_rtf_srtring_w;
					exception
					when others then
						ds_parecer_ww	:= '';
					end;
			end if;

			if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
				ds_parecer_ww := ds_parecer_ww ||
				wheb_mensagem_pck.get_texto(345000,'NR_ATENDIMENTO_W='||nr_atendimento_w) || ' \par ' ||
				wheb_mensagem_pck.get_texto(344884,'NM_PACIENTE='||nm_paciente_w) || ' \par ';
			else
				ds_parecer_ww := ds_parecer_ww ||
				wheb_mensagem_pck.get_texto(345019,'NM_PACIENTE_W='||nm_paciente_w) || ' \par ';
			end if;

			ds_parecer_ww	:= ds_parecer_ww ||wheb_mensagem_pck.get_texto(344942,'SETORW='||ds_setor_w) || ' \par ';
			ds_parecer_ww	:= ds_parecer_ww ||wheb_mensagem_pck.get_texto(344946,'DS_LEITO_W='||ds_leito_w)|| ' \par ';

			ds_parecer_ww := ds_parecer_ww ||wheb_mensagem_pck.get_texto(345022,'NM_MEDICO_W='||nm_medico_w) || ' \par ';

			if (ds_especialidade_origem_w IS NOT NULL AND ds_especialidade_origem_w::text <> '') then
				ds_parecer_ww	:= ds_parecer_ww ||wheb_mensagem_pck.get_texto(344982,'DS_ESPECIALIDADE_ORIGEM_W='||ds_especialidade_origem_w) || ' \par ';
			end if;
			if (ds_especialidade_dest_w IS NOT NULL AND ds_especialidade_dest_w::text <> '') then
				ds_parecer_ww	:= ds_parecer_ww ||wheb_mensagem_pck.get_texto(344985,'DS_ESPECIALIDADE_DEST_W='||ds_especialidade_dest_w) || ' \par ';
			end if;

			ds_parecer_ww := ds_parecer_ww || wheb_mensagem_pck.get_texto(1013115) || ' \par \par '|| substr(ds_parecer_w,position(ds_pos_inicio_rtf_w in ds_pos_inicio_rtf_w),length(ds_parecer_w));

			ds_parecer_ww	:= ds_parecer_ww||wheb_rtf_pck.get_rodape;


		end if;

		select	substr(obter_usuario_pf(cd_medico),1,100)
		into STRICT	nm_destino_w
		from	parecer_medico_req
		where	nr_parecer = nr_parecer_p;


		ds_parecer_ww	:= substr(ds_parecer_ww,1,32000);

		insert	into comunic_interna(cd_estab_destino,
				nr_sequencia,
				ds_titulo,
				dt_comunicado,
				ds_comunicado,
				nm_usuario,
				nm_usuario_destino,
				dt_atualizacao,
				ie_geral,
				ie_gerencial,
				ds_perfil_adicional,
				dt_liberacao)
		values (
				cd_estabelecimento_p,
				nr_sequencia_w,
				wheb_mensagem_pck.get_texto(344999) || ' - ' || nr_parecer_p,
				clock_timestamp(),
				ds_parecer_ww,
				nm_usuario_p,
				nm_destino_w,
				clock_timestamp(),
				'N',
				'N',
				null,
				clock_timestamp());

        begin
		nr_sequencia_ww := converte_rtf_html('select ds_comunicado from comunic_interna where nr_sequencia = :nr_sequencia_p', to_char(nr_sequencia_w), nm_usuario_p, nr_sequencia_ww);

		select	ds_texto
		into STRICT	ds_parecer_ww
		from	tasy_conversao_rtf
		where	nr_sequencia	= nr_sequencia_ww;
        exception
        when others then
            ds_parecer_ww	:= '';
        end;

		update comunic_interna set ds_comunicado = ds_parecer_ww where nr_sequencia = nr_sequencia_w;

	end if;

commit;

end if;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_comunic_parecer_html ( nr_parecer_p bigint, ie_tipo_p bigint, cd_estabelecimento_p bigint, nr_seq_parecer_p bigint, nm_usuario_p text) FROM PUBLIC;

