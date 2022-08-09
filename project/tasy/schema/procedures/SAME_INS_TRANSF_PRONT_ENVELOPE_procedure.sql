-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE same_ins_transf_pront_envelope ( nr_seq_transf_p bigint, lista_informacao_p text, nm_usuario_p text) AS $body$
DECLARE


lista_informacao_w		varchar(400);
ie_contador_w			bigint	:= 0;
tam_lista_w			bigint;
ie_pos_virgula_w		smallint;
nr_seq_pront_w			bigint;


BEGIN

lista_informacao_w	:= lista_informacao_p;

while	(lista_informacao_w IS NOT NULL AND lista_informacao_w::text <> '') or
	ie_contador_w > 200 loop
	begin
	tam_lista_w		:= length(lista_informacao_w);
	ie_pos_virgula_w	:= position(',' in lista_informacao_w);

	if (ie_pos_virgula_w <> 0) then
		nr_seq_pront_w		:= substr(lista_informacao_w,1,(ie_pos_virgula_w - 1));
		lista_informacao_w	:= substr(lista_informacao_w,(ie_pos_virgula_w + 1),tam_lista_w);
	end if;

	insert into transf_prontuario_envelope(
		nr_sequencia,
		nr_seq_transf,
		nr_seq_prontuario,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec
	) values (
		nextval('transf_prontuario_envelope_seq'),
		nr_seq_transf_p,
		nr_seq_pront_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p
	);

	ie_contador_w	:= ie_contador_w + 1;

	end;
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE same_ins_transf_pront_envelope ( nr_seq_transf_p bigint, lista_informacao_p text, nm_usuario_p text) FROM PUBLIC;
