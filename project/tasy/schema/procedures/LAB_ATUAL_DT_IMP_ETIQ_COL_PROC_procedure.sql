-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_atual_dt_imp_etiq_col_proc (nr_prescricao_p text, lista_nr_seq_prescr_p text, nm_usuario_p text) AS $body$
DECLARE


lista_nr_seq_prescr_w	varchar(4000);
tam_lista_w		bigint;
ie_pos_virgula_w	smallint;
nr_seq_prescr_w		bigint;
qtd_loop		bigint;


BEGIN
qtd_loop	:= 0;
if (lista_nr_seq_prescr_p IS NOT NULL AND lista_nr_seq_prescr_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then

	lista_nr_seq_prescr_w	:= lista_nr_seq_prescr_p;

	if (substr(lista_nr_seq_prescr_w, length(lista_nr_seq_prescr_w), 1) <> ',') then
	  lista_nr_seq_prescr_w := lista_nr_seq_prescr_w || ',';
	end if;

	while(lista_nr_seq_prescr_w IS NOT NULL AND lista_nr_seq_prescr_w::text <> '') and (qtd_loop < 100) loop
		begin
		qtd_loop 	:= qtd_loop + 1;
		tam_lista_w	:= length(lista_nr_seq_prescr_w);
		ie_pos_virgula_w:= position(',' in lista_nr_seq_prescr_w);

		if (ie_pos_virgula_w <> 0) then
			nr_seq_prescr_w	:= substr(lista_nr_seq_prescr_w,1,(ie_pos_virgula_w - 1));
			lista_nr_seq_prescr_w	:= substr(lista_nr_seq_prescr_w,(ie_pos_virgula_w + 1),tam_lista_w);
		end if;

		if (nr_seq_prescr_w IS NOT NULL AND nr_seq_prescr_w::text <> '') then
			update 	prescr_procedimento
			set		dt_imp_etiq_coleta = clock_timestamp(),
					dt_atualizacao = clock_timestamp(),
					nm_usuario = nm_usuario_p
			where 	nr_prescricao = nr_prescricao_p
			and	nr_sequencia = nr_seq_prescr_w;

		end if;

		nr_seq_prescr_w	:= null;

		end;
	end loop;

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_atual_dt_imp_etiq_col_proc (nr_prescricao_p text, lista_nr_seq_prescr_p text, nm_usuario_p text) FROM PUBLIC;

