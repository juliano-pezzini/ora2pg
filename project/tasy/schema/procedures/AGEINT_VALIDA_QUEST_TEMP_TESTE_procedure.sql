-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_valida_quest_temp_teste ( nr_seq_ageint_p bigint, cd_estabelecimento_p bigint, ie_sugestao_hor_p text default 'N', ie_sugestao_html_p text DEFAULT 'N', ds_lista_item_bloq_p INOUT text DEFAULT NULL) AS $body$
DECLARE


cd_pessoa_fisica_w		ageint_marcacao_usuario.cd_pessoa_fisica%type;
nr_seq_ageint_item_w		agenda_integrada_item.nr_sequencia%type;
cd_medico_item_w			agenda_integrada_item.cd_medico%type;
nr_seq_resp_quest_w		ageint_resp_quest_item.nr_seq_resp_quest%type;
cd_medico_quest_w		ageint_quest_utilizacao.cd_medico%type;
ie_bloquear_w			ageint_quest_regra_bloq.ie_bloquear%type;
nr_seq_resposta_w   		ageint_quest_regra_bloq.nr_seq_resposta%type;
nr_seq_resp_w   			ageint_resp_quest.nr_seq_resp%type;
nr_seq_superior_w   		ageint_quest_estrutura.nr_seq_superior%type;
ie_sugestao_hor_w			varchar(1)	:= 'N';
cd_agenda_w         		ageint_marcacao_usuario.cd_agenda%type;
hr_agenda_w         		ageint_marcacao_usuario.hr_agenda%type;
nr_minuto_duracao_w 		ageint_marcacao_usuario.nr_minuto_duracao%type;
nr_seq_ageint_w     		ageint_marcacao_usuario.nr_seq_ageint%type;
ie_encaixe_w        		ageint_marcacao_usuario.ie_encaixe%type;
nr_seq_agenda_w     		ageint_marcacao_usuario.nr_seq_agenda%type;
nr_seq_ageint_lib_w 		ageint_horarios_usuario.nr_seq_ageint_lib%type;
nm_usuario_w        		ageint_horarios_usuario.nm_usuario%type;
ie_reservado_w      		varchar(250);
ie_principal_w      		varchar(250);
ie_bloqueio_quest_w		varchar(1) := 'N';
qt_marcacao_w				bigint;
ie_sugestao_html_w      varchar(1) := 'N';
ds_lista_item_bloq_w    varchar(4000) := '';

c01 CURSOR FOR

	SELECT
		nr_sequencia,
		cd_medico
	from
		agenda_integrada_item
	where
		nr_seq_agenda_int = nr_seq_ageint_p;

c02 CURSOR FOR

	SELECT
		a.nr_seq_resp_quest,
		b.cd_medico,
		c.ie_bloquear,
		coalesce(c.nr_seq_resposta,0),
		d.nr_seq_superior
	FROM ageint_quest_estrutura d, ageint_resp_quest_item a, ageint_quest_utilizacao b
LEFT OUTER JOIN ageint_quest_regra_bloq c ON (b.nr_sequencia = c.nr_seq_quest_utilizacao AND b.nr_seq_estrutura = c.nr_seq_estrutura)
WHERE a.nr_seq_quest_utilizacao = b.nr_sequencia   and b.nr_seq_estrutura = d.nr_sequencia and a.nr_seq_item = nr_seq_ageint_item_w order by
		a.nr_seq_resp_quest desc;


BEGIN

ie_sugestao_hor_w := ie_sugestao_hor_p;
ie_sugestao_html_w := ie_sugestao_html_p;

open c01;
loop
fetch c01 into
	nr_seq_ageint_item_w,
	cd_medico_item_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select
		max(cd_pessoa_fisica),
    		max(cd_agenda),
    		max(nr_seq_agenda),
    		max(hr_agenda),
		max(nr_minuto_duracao),
    		max(nr_seq_ageint),
    		max(ie_encaixe)
	into STRICT
		cd_pessoa_fisica_w,
		cd_agenda_w,
		nr_seq_agenda_w,
		hr_agenda_w,
		nr_minuto_duracao_w,
		nr_seq_ageint_w,
		ie_encaixe_w
  	from
		ageint_marcacao_usuario
  	where
		nr_seq_ageint_item = nr_seq_ageint_item_w;

	open c02;
	loop
	fetch c02 into
		nr_seq_resp_quest_w,
		cd_medico_quest_w,
		ie_bloquear_w,
		nr_seq_resposta_w,
		nr_seq_superior_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin

		select
			max(nr_seq_resp)
		into STRICT
			nr_seq_resp_w
		from
			ageint_resp_quest
		where
			nr_sequencia = nr_seq_resp_quest_w;

		select
			max(nr_seq_ageint_lib)
		into STRICT
			nr_seq_ageint_lib_w
		from
			ageint_horarios_usuario
		where
			nr_seq_agenda = nr_seq_agenda_w
			and cd_agenda = cd_agenda_w
			and hr_agenda = hr_agenda_w
			and ie_encaixe = ie_encaixe_w
			and nr_minuto_duracao = nr_minuto_duracao_w;

		nm_usuario_w := wheb_usuario_pck.get_nm_usuario;

		if (coalesce(cd_medico_item_w::text, '') = ''
			and (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '')
			and cd_medico_quest_w = cd_pessoa_fisica_w
			and ie_bloquear_w = 'S'
			and (nr_seq_resposta_w = nr_seq_resp_w)) then

			delete from ageint_resp_quest_item where nr_seq_resp_quest = nr_seq_resp_quest_w;
			delete from ageint_resp_quest where nr_sequencia = nr_seq_resp_quest_w;

			if (ie_sugestao_hor_w = 'S') THEN
				CALL ageint_sugerir_horarios_pck.clean_item(nr_seq_ageint_item_w, 'N', 'N');
			else
				SELECT * FROM atualiza_dados_marcacao(
						cd_agenda_w, hr_agenda_w, nr_seq_ageint_w, 'D', nr_minuto_duracao_w, nm_usuario_w, nr_seq_ageint_item_w, nr_seq_ageint_lib_w, ie_encaixe_w, cd_pessoa_fisica_w, ie_Reservado_w, null, ie_principal_w, null, null) INTO STRICT ie_Reservado_w, ie_principal_w;
						
				IF (ie_sugestao_html_w = 'S') THEN
          				IF (coalesce(Length(ds_lista_item_bloq_w),0) = 0) THEN
          					ds_lista_item_bloq_w := ds_lista_item_bloq_w || nr_seq_ageint_item_w;
          				ELSE
          					ds_lista_item_bloq_w := ds_lista_item_bloq_w || ', '|| nr_seq_ageint_item_w;
          				END IF;
        			END IF;	
			end if;

		else

			select CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END
            		into STRICT ie_bloqueio_quest_w
            		from (SELECT 1
                        	from ageint_resp_quest_item  i,
                        	     ageint_resp_quest       q,
                        	     ageint_quest_regra_bloq b,
                        	     ageint_quest_utilizacao aqu
                        	 where aqu.nr_sequencia = b.nr_seq_quest_utilizacao
                        	   and b.nr_seq_quest_utilizacao = i.nr_seq_quest_utilizacao
                        	   and b.nr_seq_estrutura = q.nr_seq_estrutura
                        	   and i.nr_seq_resp_quest = q.nr_sequencia
                        	   and b.nr_seq_resposta = q.nr_seq_resp
                        	   and b.ie_situacao = 'A'
                        	   and b.ie_bloquear = 'S'
                        	   and not exists (select 1
                        	          from ageint_quest_regra_bl_item x
                        	         where b.nr_sequencia = x.nr_seq_regra_bloq
                        	           and x.ie_situacao = 'A')
                        		   and q.nr_seq_ageint = nr_seq_ageint_p
                        		   and i.nr_seq_item = nr_seq_ageint_item_w
                        
union all

                        SELECT 1
                        from ageint_resp_quest_item     i,
                             ageint_resp_quest          q,
                             ageint_quest_regra_bloq    b,
                             ageint_quest_regra_bl_item c,
                             ageint_quest_utilizacao    aqu
                        where aqu.nr_sequencia = b.nr_seq_quest_utilizacao
                             and b.nr_seq_quest_utilizacao = i.nr_seq_quest_utilizacao
                             and b.nr_seq_estrutura = q.nr_seq_estrutura
                             and i.nr_seq_resp_quest = q.nr_sequencia
                             and b.nr_seq_resposta = q.nr_seq_resp
                             and b.nr_sequencia = c.nr_seq_regra_bloq
                             and b.ie_situacao = 'A'
                             and b.ie_bloquear = 'S'
                             and c.ie_situacao = 'A'
                             and q.nr_seq_ageint = nr_seq_ageint_p
                             and i.nr_seq_item = nr_seq_ageint_item_w
                             and c.cd_agenda = cd_agenda_w) alias2;

      			if (ie_bloqueio_quest_w = 'S') then
					select count(*)
					into STRICT	qt_marcacao_w
					from ageint_marcacao_usuario
					where	nr_seq_ageint = nr_Seq_Ageint_w
					and		nr_seq_ageint_item	= nr_Seq_Ageint_item_w;
					if (qt_marcacao_w > 0) then
						SELECT * FROM atualiza_dados_marcacao(
								cd_agenda_w, hr_agenda_w, nr_seq_ageint_w, 'D', nr_minuto_duracao_w, nm_usuario_w, nr_seq_ageint_item_w, nr_seq_ageint_lib_w, ie_encaixe_w, cd_pessoa_fisica_w, ie_Reservado_w, null, ie_principal_w, null, null) INTO STRICT ie_Reservado_w, ie_principal_w;
					end if;
      			end if;

		end if;

		end;

	end loop;
	close c02;

	end;
end loop;
close c01;

commit;

ds_lista_item_bloq_p := ds_lista_item_bloq_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_valida_quest_temp_teste ( nr_seq_ageint_p bigint, cd_estabelecimento_p bigint, ie_sugestao_hor_p text default 'N', ie_sugestao_html_p text DEFAULT 'N', ds_lista_item_bloq_p INOUT text DEFAULT NULL) FROM PUBLIC;
