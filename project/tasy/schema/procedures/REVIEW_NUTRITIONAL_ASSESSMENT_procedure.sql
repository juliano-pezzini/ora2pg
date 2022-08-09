-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE review_nutritional_assessment (nr_seq_aval_nutricao_orig_p bigint, nr_seq_aval_nutricao_copy_p bigint, ie_acao_p text, nm_usuario_p text ) AS $body$
DECLARE


nr_seq_aval_nutricao_w 	aval_nutricao.nr_seq_aval_nutricao%type;

ie_acao_copiar_w             constant varchar(1) := 'C';
ie_acao_liberar_w            constant varchar(1) := 'L';
ie_acao_excluir_w            constant varchar(1) := 'E';
ie_acao_clonar_review_w      constant varchar(1) := 'R';
ie_temp_save_w               aval_nutricao.ie_status%type := 'TS';
ie_review_w                  aval_nutricao.ie_revisado%type := 'N';
ie_active_w                  aval_nutricao.ie_situacao%type := 'A';				

BEGIN

if (ie_acao_p = ie_acao_copiar_w) then
	
	update 	aval_nutricao
	set 	nr_seq_aval_nutricao = nr_seq_aval_nutricao_orig_p,
			dt_liberacao  = NULL,
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp(),
      ie_status = 'TS'
	where	nr_sequencia = nr_seq_aval_nutricao_copy_p;
	
	update 	aval_nutricao
	set 	ie_revisado = 'N',
        ie_status   = 'N',
        dt_inativacao = clock_timestamp(),
        ie_situacao = 'I',
        nm_usuario_inativacao = nm_usuario_p,
        ds_justificativa = obter_expressao_idioma(776344)
	where	nr_sequencia = nr_seq_aval_nutricao_orig_p;

elsif (ie_acao_p = ie_acao_liberar_w) then
	
	begin
		select 	nr_seq_aval_nutricao
		into STRICT 	nr_seq_aval_nutricao_w
		from 	aval_nutricao
		where 	nr_sequencia = nr_seq_aval_nutricao_orig_p;
		
		update 	aval_nutricao
		set 	ie_revisado = 'S',
				nm_usuario = nm_usuario_p,
				dt_atualizacao = clock_timestamp()				
		where	nr_sequencia = nr_seq_aval_nutricao_w;
		
		
		if (nr_seq_aval_nutricao_w IS NOT NULL AND nr_seq_aval_nutricao_w::text <> '')then
			update 	aval_nutricao
			set 	ie_revisado = 'R',
					nm_usuario = nm_usuario_p,
					dt_atualizacao = clock_timestamp()				
			where	nr_sequencia = nr_seq_aval_nutricao_orig_p;
		end if;
		
	exception
	when others then
		nr_seq_aval_nutricao_w := null;
	end;

  elsif (ie_acao_p = ie_acao_clonar_review_w) then

	update 	aval_nutricao
	set dt_liberacao  = NULL,
	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp(),
	ie_revisado = ie_review_w,
	ie_status = ie_temp_save_w,
	ie_situacao = ie_active_w,
	dt_inativacao  = NULL,
	nm_usuario_inativacao  = NULL,
	ds_justificativa  = NULL
	where	nr_sequencia = nr_seq_aval_nutricao_copy_p;
	
else
	begin
		select 	nr_seq_aval_nutricao
		into STRICT 	nr_seq_aval_nutricao_w
		from 	aval_nutricao
		where 	nr_sequencia = nr_seq_aval_nutricao_orig_p;
		
		update 	aval_nutricao
		set 	ie_revisado  = NULL,
				nm_usuario = nm_usuario_p,
				dt_atualizacao = clock_timestamp()				
		where	nr_sequencia = nr_seq_aval_nutricao_w;
		
	exception
	when others then
		nr_seq_aval_nutricao_w := null;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE review_nutritional_assessment (nr_seq_aval_nutricao_orig_p bigint, nr_seq_aval_nutricao_copy_p bigint, ie_acao_p text, nm_usuario_p text ) FROM PUBLIC;
