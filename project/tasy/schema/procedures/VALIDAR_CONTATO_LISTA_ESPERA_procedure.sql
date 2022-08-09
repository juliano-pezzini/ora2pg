-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE validar_contato_lista_espera ( nr_seq_contato_p bigint) AS $body$
DECLARE


ie_tipo_contato_w	varchar(10);			
nr_seq_lista_espera_w	bigint;
nr_seq_pac_mut_w		bigint;
nr_seq_mutirao_w		bigint;


BEGIN

if (nr_seq_contato_p IS NOT NULL AND nr_seq_contato_p::text <> '')then

	select  max(b.ie_tipo_contato),
			max(a.nr_seq_lista_espera)
	into STRICT 	ie_tipo_contato_w,
			nr_seq_lista_espera_w
	from    ag_lista_espera_contato a,
			lista_espera_situacao_cont b
	where   a.nr_seq_situacao_atual = b.nr_sequencia
	and     b.ie_situacao = 'A'
	and     a.nr_sequencia = nr_seq_contato_p;
	
	if (coalesce(ie_tipo_contato_w, 'XPTO') = 'PJ' and (nr_seq_lista_espera_w IS NOT NULL AND nr_seq_lista_espera_w::text <> ''))then

		update agenda_lista_espera
		set ie_status_espera = 'C',
			dt_atualizacao = clock_timestamp(),
			nm_usuario = substr(wheb_usuario_pck.get_nm_usuario,1,15)
		where nr_sequencia = nr_seq_lista_espera_w;

		
		select  max(nr_sequencia),
				max(nr_seq_mutirao)
		into STRICT 	nr_seq_pac_mut_w,
				nr_seq_mutirao_w
		from    paciente_mutirao
		where   nr_seq_lista_espera = nr_seq_lista_espera_w;
		
		if (nr_seq_pac_mut_w IS NOT NULL AND nr_seq_pac_mut_w::text <> '')then
		
			update  paciente_mutirao
			set 	dt_exclusao = clock_timestamp()
			where   nr_sequencia = nr_seq_pac_mut_w;
		
			commit;
			
			CALL gerar_participante_mutirao(nr_seq_mutirao_w, wheb_usuario_pck.get_nm_usuario);
		
		
		end if;
		
	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE validar_contato_lista_espera ( nr_seq_contato_p bigint) FROM PUBLIC;
