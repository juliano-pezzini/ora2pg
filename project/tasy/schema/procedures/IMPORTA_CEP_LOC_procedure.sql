-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importa_cep_loc ( nr_sequencia_p bigint, nm_localidade_p text, cd_cep_p bigint, ds_uf_p text, ie_tipo_p text, nr_seq_superior_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_existe_w	integer:= 0;


BEGIN

if (obter_se_uf_valido(ds_uf_p)) then

	select	count(*)
	into STRICT	qt_existe_w
	from	cep_loc
	where	nr_sequencia = nr_sequencia_p;

	if (qt_existe_w > 0) then
		/*(-20011,'Já existe um cadastro com a sequência: ' || nr_sequencia_p);*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(263189,'NR_SEQUENCIA=' || nr_sequencia_p);
	else
		insert into cep_loc(
				nr_sequencia,
				nm_localidade,
				cd_cep,
				ds_uf,
				ie_tipo,
				nr_seq_superior,
				dt_atualizacao,
				nm_usuario)
			values (nr_sequencia_p,
				nm_localidade_p,
				cd_cep_p,
				ds_uf_p,
				ie_tipo_p,
				nr_seq_superior_p,
				clock_timestamp(),
				nm_usuario_p);
	end if;
else
	insert into	log_mov( dt_atualizacao
						, nm_usuario
						, ds_log
						, cd_log)
				values ( clock_timestamp()
						, obter_usuario_Ativo
						, 'nr_sequencia_p:' || nr_sequencia_p || chr(13) ||
						  'nm_localidade_p:' || nm_localidade_p || chr(13) ||
						  'cd_cep_p:' || cd_cep_p || chr(13) ||
						  'ds_uf_p:' || ds_uf_p || chr(13) ||
						  'ie_tipo_p:' || ie_tipo_p || chr(13) ||
						  'nr_seq_superior_p:' || nr_seq_superior_p || chr(13) ||
						  'nm_usuario_p:' || nm_usuario_p
						, 1574783);
end if;

commit;
end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importa_cep_loc ( nr_sequencia_p bigint, nm_localidade_p text, cd_cep_p bigint, ds_uf_p text, ie_tipo_p text, nr_seq_superior_p bigint, nm_usuario_p text) FROM PUBLIC;
