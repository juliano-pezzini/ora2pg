-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE agecons_val_permissao_espec (cd_estabelecimento_p bigint, nr_seq_agenda_p bigint, cd_medico_p bigint, cd_agenda_p bigint, cd_pessoa_fisica_p bigint, dt_agenda_p timestamp, cd_mensagem_p INOUT bigint, ie_acao_p INOUT text, ds_mensagem_p INOUT text) AS $body$
DECLARE


nr_seq_regra_w regra_perm_agenda_espec.nr_sequencia%type := null;
ie_acao_w regra_perm_agenda_espec.ie_acao%type;
ie_acao_ret_w regra_perm_agenda_espec.ie_acao%type := null;
ie_mesmo_estab_w regra_perm_agenda_espec.ie_mesmo_estab%type;
ie_mesma_agenda_w regra_perm_agenda_espec.ie_mesma_agenda%type;
ie_mesmo_medico_w regra_perm_agenda_espec.ie_mesmo_medico%type;
ie_considera_retorno_w regra_perm_agenda_espec.ie_considera_retorno%type;
nr_dias_validacao_w regra_perm_agenda_espec.nr_dias_validacao%type;
ie_possui_agendas_w bigint := 0;
cd_mensagem_w bigint := 0;
cd_esp_agenda_w agenda.cd_especialidade%type;
ds_mensagem_w varchar(1000) := null;

c01_regra CURSOR FOR
SELECT nr_sequencia,
	   ie_acao,
	   coalesce(ie_mesmo_estab,'N'),
	   coalesce(ie_mesma_agenda,'N'),
	   coalesce(ie_mesmo_medico,'N'),
	   coalesce(ie_considera_retorno,'N'),
	   nr_dias_validacao
  from regra_perm_agenda_espec
 where coalesce(cd_estabelecimento,cd_estabelecimento_p) = cd_estabelecimento_p
   and cd_especialidade = cd_esp_agenda_w
   and ie_situacao = 'A'
   order by coalesce(cd_estabelecimento,0);

c02_regra CURSOR FOR
	SELECT 	a.cd_especialidade
	from 	agenda_cons_especialidade a
	where 	a.cd_agenda = cd_agenda_p;


BEGIN

	select max(cd_especialidade)
	  into STRICT cd_esp_agenda_w
	  from agenda
	 where cd_agenda = cd_agenda_p;
	
	open c01_regra;
      loop
      fetch c01_regra into
        nr_seq_regra_w,
        ie_acao_w,
        ie_mesmo_estab_w,
        ie_mesma_agenda_w,
        ie_mesmo_medico_w,
		ie_considera_retorno_w,
		nr_dias_validacao_w;
      EXIT WHEN NOT FOUND; /* apply on c01_regra */
        begin

			nr_seq_regra_w := nr_seq_regra_w;
			ie_acao_w := ie_acao_w;
			ie_mesmo_estab_w := ie_mesmo_estab_w;
			ie_mesma_agenda_w := ie_mesma_agenda_w;
			ie_mesmo_medico_w := ie_mesmo_medico_w;
			ie_considera_retorno_w := ie_considera_retorno_w;
			nr_dias_validacao_w := nr_dias_validacao_w;

		end;
	  end loop;
	close c01_regra;

	if (nr_seq_regra_w > 0) then

		select count(*)
		  into STRICT ie_possui_agendas_w
		  FROM agenda_consulta ac, agenda a
LEFT OUTER JOIN agenda_cons_especialidade ae ON (a.cd_agenda = ae.cd_agenda)
WHERE a.cd_agenda = ac.cd_agenda  and ac.cd_pessoa_fisica = cd_pessoa_fisica_p and (ae.cd_especialidade = cd_esp_agenda_w or a.cd_especialidade = cd_esp_agenda_w) and ((a.cd_pessoa_fisica = cd_medico_p and ie_mesmo_medico_w = 'S') or ie_mesmo_medico_w = 'N') and ((coalesce(a.cd_estabelecimento,cd_estabelecimento_p) = cd_estabelecimento_p and  ie_mesmo_estab_w = 'S') or ie_mesmo_estab_w = 'N') and ((ac.cd_agenda = cd_agenda_p and ie_mesma_agenda_w = 'S') or ie_mesma_agenda_w = 'N') and dt_agenda_p between pkg_date_utils.start_of(ac.dt_agenda,'DAY') - nr_dias_validacao_w and pkg_date_utils.end_of(ac.dt_agenda,'DAY') + nr_dias_validacao_w and (ac.nr_sequencia <> nr_seq_agenda_p or coalesce(nr_seq_agenda_p::text, '') = '') and ac.ie_status_agenda not in ('C','F','L','LF','I','B') and ((ie_considera_retorno_w = 'S')
		   or (ie_considera_retorno_w = 'N' and ie_classif_agenda not in ( SELECT cd_classificacao
																		     from agenda_classif
	  																	    where ie_tipo_classif in ('R', 'U')) ));

			if (ie_possui_agendas_w > 0) then
				cd_mensagem_p := 1121652;
				ie_acao_p := ie_acao_w;
				ds_mensagem_p := wheb_mensagem_pck.get_texto(1121652);
			end if;	
	end if;

	if (coalesce(ie_acao_w, 'X') <> 'B') then
		open c02_regra;
		  loop
		  fetch c02_regra into
		    cd_esp_agenda_w;
		  EXIT WHEN NOT FOUND; /* apply on c02_regra */
			begin

				open c01_regra;
			      loop
				  fetch c01_regra into
					nr_seq_regra_w,
					ie_acao_w,
					ie_mesmo_estab_w,
					ie_mesma_agenda_w,
					ie_mesmo_medico_w,
					ie_considera_retorno_w,
					nr_dias_validacao_w;
				  EXIT WHEN NOT FOUND; /* apply on c01_regra */
					begin

						nr_seq_regra_w := nr_seq_regra_w;
						ie_acao_w := ie_acao_w;
						ie_mesmo_estab_w := ie_mesmo_estab_w;
						ie_mesma_agenda_w := ie_mesma_agenda_w;
						ie_mesmo_medico_w := ie_mesmo_medico_w;
						ie_considera_retorno_w := ie_considera_retorno_w;
						nr_dias_validacao_w := nr_dias_validacao_w;

					end;
			      end loop;
				close c01_regra;

				if (nr_seq_regra_w > 0) then

					select count(*)
					  into STRICT ie_possui_agendas_w
				      FROM agenda_consulta ac, agenda a
LEFT OUTER JOIN agenda_cons_especialidade ae ON (a.cd_agenda = ae.cd_agenda)
WHERE a.cd_agenda = ac.cd_agenda  and ac.cd_pessoa_fisica = cd_pessoa_fisica_p and (ae.cd_especialidade = cd_esp_agenda_w or a.cd_especialidade = cd_esp_agenda_w) and ((a.cd_pessoa_fisica = cd_medico_p and ie_mesmo_medico_w = 'S') or ie_mesmo_medico_w = 'N') and ((coalesce(a.cd_estabelecimento,cd_estabelecimento_p) = cd_estabelecimento_p and  ie_mesmo_estab_w = 'S') or ie_mesmo_estab_w = 'N') and ((ac.cd_agenda = cd_agenda_p and ie_mesma_agenda_w = 'S') or ie_mesma_agenda_w = 'N') and dt_agenda_p between pkg_date_utils.start_of(ac.dt_agenda,'DAY') - nr_dias_validacao_w and pkg_date_utils.end_of(ac.dt_agenda,'DAY') + nr_dias_validacao_w and (ac.nr_sequencia <> nr_seq_agenda_p or coalesce(nr_seq_agenda_p::text, '') = '') and ac.ie_status_agenda not in ('C','F','L','LF','I','B') and ((ie_considera_retorno_w = 'S')
			          or (ie_considera_retorno_w = 'N' and ie_classif_agenda not in ( SELECT cd_classificacao
																					from agenda_classif
																				   where ie_tipo_classif in ('R', 'U')) ));

					  if (ie_possui_agendas_w > 0) then
						  cd_mensagem_p := 1121652;
						  ie_acao_p := ie_acao_w;
						  ds_mensagem_p := wheb_mensagem_pck.get_texto(1121652);
					  end if;
				end if;

			if (coalesce(ie_acao_w,'X')	= 'B') then
				exit;
			end if;

			end;
		  end loop;
		  close c02_regra;
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE agecons_val_permissao_espec (cd_estabelecimento_p bigint, nr_seq_agenda_p bigint, cd_medico_p bigint, cd_agenda_p bigint, cd_pessoa_fisica_p bigint, dt_agenda_p timestamp, cd_mensagem_p INOUT bigint, ie_acao_p INOUT text, ds_mensagem_p INOUT text) FROM PUBLIC;

