-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_status_cooperado ( nr_seq_cooperado_p text, nr_seq_motivo_p text, ds_motivo_p text, ie_opcao_p text, nm_usuario_p text, nr_seq_situacao_p text, dt_alteracao_p timestamp) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Alterar a situacao do cooperado e gerar os historicos.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
	ie_opcao_p:
		A - Ativar Cooperado
		S - Suspender Cooperado
		I - Inativar Cooperado
		
	PLS_COOPERADO_ATUAL
-------------------------------------------------------------------------------------------------------------------

Referencias:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_pessoa_fisica_w		pls_cooperado.cd_pessoa_fisica%type;
cd_cgc_w			pls_cooperado.cd_cgc%type;


BEGIN

select	max(cd_pessoa_fisica),
	max(cd_cgc)
into STRICT	cd_pessoa_fisica_w,
	cd_cgc_w
from	pls_cooperado
where	nr_sequencia = nr_seq_cooperado_p;

CALL pls_consistir_cad_medico_coop(cd_pessoa_fisica_w, cd_cgc_w, dt_alteracao_p, nr_seq_cooperado_p, nm_usuario_p);

if (ie_opcao_p = 'A') then
	insert into pls_cooperado_situacao(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_cooperado,
		ds_motivo,
		dt_alteracao,
		dt_status,
		ie_situacao,
		nr_seq_motivo_susp,
		nr_seq_situacao_coop)
	values (nextval('pls_cooperado_situacao_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_cooperado_p,
		ds_motivo_p,
		clock_timestamp(),
		dt_alteracao_p,
		'A',
		nr_seq_motivo_p,
		nr_seq_situacao_p);
	
	CALL wheb_usuario_pck.set_ie_executar_trigger('N');
	
	update	pls_cooperado
	set	dt_suspensao	 = NULL,
		dt_exclusao	 = NULL,
		dt_inclusao	= dt_alteracao_p,
		ie_status	= 'A',
		nr_seq_situacao	= nr_seq_situacao_p
	where	nr_sequencia	= nr_seq_cooperado_p;

	CALL wheb_usuario_pck.set_ie_executar_trigger('S');	

elsif (ie_opcao_p = 'I') then
	insert into pls_cooperado_situacao(nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		ie_situacao,
		nr_seq_cooperado,
		nr_seq_motivo_susp,
		ds_motivo,
		dt_alteracao,
		dt_status,
		nr_seq_situacao_coop)
	values (nextval('pls_cooperado_situacao_seq'),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		'I',
		nr_seq_cooperado_p,
		nr_seq_motivo_p,
		ds_motivo_p,
		clock_timestamp(),
		dt_alteracao_p,
		nr_seq_situacao_p);

	CALL wheb_usuario_pck.set_ie_executar_trigger('N');
	
	update	pls_cooperado
	set	dt_exclusao	= dt_alteracao_p,
		ie_status	= 'I',
		nr_seq_situacao	= nr_seq_situacao_p
	where	nr_sequencia	= nr_seq_cooperado_p;
	
	CALL wheb_usuario_pck.set_ie_executar_trigger('S');
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_status_cooperado ( nr_seq_cooperado_p text, nr_seq_motivo_p text, ds_motivo_p text, ie_opcao_p text, nm_usuario_p text, nr_seq_situacao_p text, dt_alteracao_p timestamp) FROM PUBLIC;
