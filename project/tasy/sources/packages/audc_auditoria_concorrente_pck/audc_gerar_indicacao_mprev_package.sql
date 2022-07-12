-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE audc_auditoria_concorrente_pck.audc_gerar_indicacao_mprev ( nr_seq_audc_atend_p audc_atendimento.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, ds_observacao_p audc_indicacao_promoprev.ds_observacao%type, nr_seq_mprev_programa_p audc_indicacao_promoprev.nr_seq_mprev_programa%type, ie_home_care_p audc_indicacao_promoprev.ie_home_care%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Gerar a indicacao de programa de saude e medicina preventiva.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
nr_seq_indicacao_old_w		mprev_indicacao_paciente.nr_sequencia%type;
nr_seq_indicacao_w		mprev_indicacao_paciente.nr_sequencia%type;
cd_pessoa_fisica_usuario_w	pessoa_fisica.cd_pessoa_fisica%type;
nr_seq_captacao_w		mprev_captacao.nr_sequencia%type;
ds_mensagem_retorno_w		varchar(255);
ie_abortar_confirm_w		varchar(1);
nr_seq_programa_w		mprev_programa.nr_sequencia%type;
qt_programa_w			integer;	

c02 CURSOR FOR
	SELECT	nr_sequencia
	from	mprev_indicacao_paciente
	where	nm_usuario		= nm_usuario_p
	and	coalesce(dt_confirmacao::text, '') = '' 
	and	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	cd_pessoa_indicante	= cd_pessoa_fisica_usuario_w;


BEGIN

select	cd_pessoa_fisica
into STRICT	cd_pessoa_fisica_w
from 	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

select	cd_pessoa_fisica
into STRICT	cd_pessoa_fisica_usuario_w
from 	wsuite_usuario
where	ds_login	= nm_usuario_p;
		
select	count(1)
into STRICT	qt_programa_w
from	mprev_captacao_destino y,
	mprev_captacao x
where	x.nr_sequencia		= y.nr_seq_captacao
and	y.nr_seq_programa	= nr_seq_mprev_programa_p
and	x.cd_pessoa_fisica	= cd_pessoa_fisica_w
and	x.ie_status in ('P','T');

if (qt_programa_w > 0) then
	--O beneficiario ja possui indicacao para este programa.

	CALL wheb_mensagem_pck.exibir_mensagem_abort(1096779,'');
end if;
	
select  count(1)
into STRICT	qt_programa_w
from    mprev_programa_partic x,
	mprev_participante y
where   y.nr_sequencia		= x.nr_seq_participante
and     x.nr_seq_programa	= nr_seq_mprev_programa_p
and     y.cd_pessoa_fisica	= cd_pessoa_fisica_w
and     clock_timestamp() between x.dt_inclusao and coalesce(x.dt_exclusao,clock_timestamp());	

if (qt_programa_w > 0) then
	--O beneficiario ja particpa deste programa.

	CALL wheb_mensagem_pck.exibir_mensagem_abort(1096780,'');
end if;

insert into audc_indicacao_promoprev(	nr_sequencia, nr_seq_audc_atend, nr_seq_segurado,
					nr_seq_mprev_programa, ie_home_care, dt_atualizacao, 						
					dt_atualizacao_nrec, nm_usuario, nm_usuario_nrec,
					ds_observacao, dt_indicacao)
				values (	nextval('audc_indicacao_promoprev_seq'), nr_seq_audc_atend_p, nr_seq_segurado_p,
					nr_seq_mprev_programa_p, ie_home_care_p, clock_timestamp(),
					clock_timestamp(), nm_usuario_p, nm_usuario_p,
					ds_observacao_p, clock_timestamp());

open c02;
loop
fetch c02 into
	nr_seq_indicacao_old_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin	
	delete 	FROM mprev_captacao_diagnostico
	where	nr_seq_captacao in (	SELECT	nr_sequencia
					from	mprev_captacao
					where	nr_seq_indicacao = nr_seq_indicacao_old_w);

	delete 	FROM mprev_captacao_destino
	where	nr_seq_captacao in (	SELECT	nr_sequencia
					from	mprev_captacao
					where	nr_seq_indicacao = nr_seq_indicacao_old_w);

	delete	FROM mprev_captacao
	where	nr_seq_indicacao = nr_seq_indicacao_old_w;

	delete  FROM mprev_indicacao_paciente
	where	nr_sequencia = nr_seq_indicacao_old_w;					
	end;
end loop;
close c02;

insert into  mprev_indicacao_paciente(  nr_sequencia, dt_atualizacao, nm_usuario,
					dt_atualizacao_nrec, nm_usuario_nrec, cd_pessoa_fisica,
					dt_indicacao, cd_pessoa_indicante, ds_observacao)
				values (	nextval('mprev_indicacao_paciente_seq'), clock_timestamp(), nm_usuario_p,
					clock_timestamp(), nm_usuario_p, cd_pessoa_fisica_w,
					clock_timestamp(), cd_pessoa_fisica_usuario_w, ds_observacao_p) returning nr_sequencia into nr_seq_indicacao_w;
				
mprev_gerar_captacao_indicacao(nr_seq_indicacao_w, nm_usuario_p, nr_seq_captacao_w);
	
insert into mprev_captacao_destino( 	nr_sequencia, dt_atualizacao, nm_usuario,
					dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_captacao,
					nr_seq_programa)
				values (	nextval('mprev_captacao_destino_seq'), clock_timestamp(), nm_usuario_p,
					clock_timestamp(), nm_usuario_p, nr_seq_captacao_w,
					nr_seq_mprev_programa_p);	
commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE audc_auditoria_concorrente_pck.audc_gerar_indicacao_mprev ( nr_seq_audc_atend_p audc_atendimento.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, ds_observacao_p audc_indicacao_promoprev.ds_observacao%type, nr_seq_mprev_programa_p audc_indicacao_promoprev.nr_seq_mprev_programa%type, ie_home_care_p audc_indicacao_promoprev.ie_home_care%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
