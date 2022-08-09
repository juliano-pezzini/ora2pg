-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE same_inserir_solic_agenda ( nr_seq_lote_p bigint, lista_informacao_p text, nm_usuario_p text) AS $body$
DECLARE


lista_informacao_w		varchar(4000);
ie_contador_w			bigint	:= 0;
tam_lista_w			bigint;
ie_pos_virgula_w		smallint;
nr_seq_agecons_w		agenda_consulta.nr_sequencia%type;
cd_pessoa_fisica_w		varchar(10);
cd_agenda_w			bigint;
dt_agenda_w			timestamp;
cd_setor_atendimento_w		bigint;


BEGIN

if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then

	lista_informacao_w	:= lista_informacao_p;

	while(lista_informacao_w IS NOT NULL AND lista_informacao_w::text <> '') or (ie_contador_w > 200) loop
		begin
		tam_lista_w		:= length(lista_informacao_w);
		ie_pos_virgula_w	:= position(',' in lista_informacao_w);

		if (ie_pos_virgula_w <> 0) then
			nr_seq_agecons_w	:= substr(lista_informacao_w,1,(ie_pos_virgula_w - 1));
			lista_informacao_w	:= substr(lista_informacao_w,(ie_pos_virgula_w + 1),tam_lista_w);
		end if;
		
		if (nr_seq_agecons_w IS NOT NULL AND nr_seq_agecons_w::text <> '') then
		
			select	cd_pessoa_fisica,
				cd_agenda,
				dt_agenda,
				cd_setor_atendimento
			into STRICT	cd_pessoa_fisica_w,
				cd_agenda_w,
				dt_agenda_w,
				cd_setor_atendimento_w
			from	agenda_consulta
			where	nr_sequencia = nr_seq_agecons_w;
			
			CALL Gerar_Solic_Pront_Agenda_GP(cd_pessoa_fisica_w, nr_seq_agecons_w, cd_agenda_w, dt_agenda_w, nm_usuario_p, cd_setor_atendimento_w, nr_seq_lote_p, null);
		end if;
		
		ie_contador_w	:= ie_contador_w + 1;
		
		end;
	end loop;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE same_inserir_solic_agenda ( nr_seq_lote_p bigint, lista_informacao_p text, nm_usuario_p text) FROM PUBLIC;
