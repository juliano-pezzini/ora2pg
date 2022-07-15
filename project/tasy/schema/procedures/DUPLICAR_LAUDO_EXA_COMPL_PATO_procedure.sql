-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_laudo_exa_compl_pato (nr_sequencia_p bigint, ds_lista_p text, nm_usuario_p text, nr_seq_laudo_novo_p INOUT text) AS $body$
DECLARE


nr_seq_laudo_w		bigint;
ds_lista_w		varchar(255);
ds_lista_2_w		varchar(255);
nr_seq_exame_w		varchar(100);
ie_pos_virgula_w	bigint;
tam_lista_w		bigint;
nr_seq_laudo_novo_w	bigint;

ie_possui_anticorpos_ant_w	varchar(1);
ie_possui_anticorpos_w		varchar(1);


BEGIN

select nextval('laudo_paciente_seq')
into STRICT nr_seq_laudo_w
;

insert into laudo_paciente(	nr_sequencia,
				nr_atendimento,
				dt_entrada_unidade,
				nr_laudo,
				nm_usuario,
				dt_atualizacao,
				cd_medico_resp,
				ds_titulo_laudo,
				dt_laudo,
				cd_laudo_padrao,
				ie_normal,
				dt_exame,
				nr_prescricao,
				ds_laudo,
				cd_protocolo,
				cd_projeto,
				nr_seq_proc,
				nr_seq_prescricao,
				dt_prev_entrega,
				dt_real_entrega,
				qt_imagem,
				nr_seq_superior,
				nr_exame)
				SELECT	nr_seq_laudo_w,
					nr_atendimento,
					dt_entrada_unidade,
					nr_seq_laudo_w,
					nm_usuario_p,
					clock_timestamp(),
					cd_medico_resp,
					ds_titulo_laudo,
					dt_laudo,
					cd_laudo_padrao,
					ie_normal,
					dt_exame,
					nr_prescricao,
					null,
					cd_protocolo,
					cd_projeto,
					nr_seq_proc,
					nr_seq_prescricao,
					dt_prev_entrega,
					dt_real_entrega,
					qt_imagem,
					nr_sequencia_p,
					nr_exame
				from laudo_paciente
				where nr_sequencia = nr_sequencia_p;

CALL Vincular_Procedimento_Laudo(nr_seq_laudo_w,'N',nm_usuario_p);

ds_lista_2_w := null;
ie_possui_anticorpos_ant_w := null;
ds_lista_w := ds_lista_p;
while(ds_lista_w IS NOT NULL AND ds_lista_w::text <> '')  loop
	begin

	tam_lista_w	 := length(ds_lista_w);
	ie_pos_virgula_w := position(',' in ds_lista_w);

	if (ie_pos_virgula_w <> 0) then
		nr_seq_exame_w	:= (substr(ds_lista_w,1,(ie_pos_virgula_w - 1)))::numeric;
		ds_lista_w	:= substr(ds_lista_w,(ie_pos_virgula_w + 1),tam_lista_w);
	end if;

	if (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then

		--Verifica se o exame complementar possui anticorpo
		select 	max(p.ie_possui_anticorpos)
		into STRICT	ie_possui_anticorpos_w
		from	patologia_exame_compl p,
			prescr_proc_exame_compl c
		where	p.nr_sequencia = c.nr_seq_pato_exame
		and	c.nr_sequencia = nr_seq_exame_w;


		--Caso o "possui anticorpo" do exame  complementar  for igual ao último exame incluído é insewrido
		if	((ie_possui_anticorpos_w = ie_possui_anticorpos_ant_w) or (coalesce(ie_possui_anticorpos_ant_w::text, '') = '')) then

			insert into 	laudo_pac_exame_compl(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_exame_compl,
					nr_seq_laudo
					)
			values (
					nextval('laudo_pac_exame_compl_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_exame_w,
					nr_seq_laudo_w
					);

		else

			--Caso o "possui anticorpo" do exame complemetar for diferente é incluído na lista de pendente
			ds_lista_2_w :=  nr_seq_exame_w||','||ds_lista_2_w;


		end if;

		ie_possui_anticorpos_ant_w := ie_possui_anticorpos_w;

	end if;


	end;
	end loop;



if (ds_lista_2_w IS NOT NULL AND ds_lista_2_w::text <> '')	then

	--Duplica os laudos para os exames complentares que possuírem o valor do campo "possui anticorpo diferente"
	nr_seq_laudo_novo_w := duplicar_laudo_exa_compl_pato(nr_sequencia_p, ds_lista_2_w, nm_usuario_p, nr_seq_laudo_novo_w);

end if;

nr_seq_laudo_novo_p := nr_seq_laudo_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_laudo_exa_compl_pato (nr_sequencia_p bigint, ds_lista_p text, nm_usuario_p text, nr_seq_laudo_novo_p INOUT text) FROM PUBLIC;

