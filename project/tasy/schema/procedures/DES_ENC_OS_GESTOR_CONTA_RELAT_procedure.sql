-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE des_enc_os_gestor_conta_relat ( nr_sequencia_p bigint, nm_usuario_p text, ie_envia_relatorio_p text default 'N', ds_email_relat_p INOUT text  DEFAULT NULL) AS $body$
DECLARE


nm_usuario_gestor_w		varchar(15);
qt_existe_w				bigint;
ds_historico_os_w		varchar(4000);
ds_titulo_w				varchar(255);
ds_comunic_w			varchar(4000);
ds_email_w				varchar(255);
ie_erro_mail_w			varchar(1);
nr_seq_rtf_srtring_w	bigint;
nr_seq_cliente_w		bigint;
nr_seq_envio_w			bigint;


BEGIN

select	nr_seq_cliente
into STRICT	nr_seq_cliente_w
from	man_ordem_servico
where	nr_sequencia = nr_sequencia_p;

begin
select	coalesce(substr(obter_usuario_pf(cd_pessoa_fisica),1,15),'pcfelix')
into STRICT	nm_usuario_gestor_w
from	com_cliente_conta
where	nr_seq_cliente = nr_seq_cliente_w
and	clock_timestamp() between coalesce(dt_inicial,clock_timestamp()) and coalesce(dt_final,clock_timestamp())  LIMIT 1;
exception
when others then
	nm_usuario_gestor_w := 'pcfelix';
end;

select	count(*)
into STRICT	qt_existe_w
from	man_ordem_servico_exec
where	nr_seq_ordem 	= nr_sequencia_p
and	nm_usuario_exec 	= nm_usuario_gestor_w;
	
if (qt_existe_w = 0) then
	insert into man_ordem_servico_exec(
			nr_sequencia,
			nr_seq_ordem,
			dt_atualizacao,
			nm_usuario,
			nm_usuario_exec,
			qt_min_prev,
			nr_seq_tipo_exec,
			dt_atualizacao_nrec,
			nm_usuario_nrec)
		values (	nextval('man_ordem_servico_exec_seq'),
			nr_sequencia_p,
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_gestor_w,
			45,
			'3',
			clock_timestamp(),
			nm_usuario_p);
end if;

update	man_ordem_servico
set	nr_seq_estagio = 371,
	dt_atualizacao = clock_timestamp(),
	nm_usuario = nm_usuario_p
where	nr_sequencia = nr_sequencia_p;

update	man_ordem_servico_exec
set	dt_fim_execucao 	= clock_timestamp()
where	nr_seq_ordem 		= nr_sequencia_p
and	nm_usuario_exec 	= nm_usuario_p
and	coalesce(dt_fim_execucao::text, '') = '';

begin
nr_seq_rtf_srtring_w := converte_rtf_string('select ds_relat_tecnico from man_ordem_serv_tecnico where nr_seq_ordem_serv = :nr_sequencia_p', nr_sequencia_p, nm_usuario_p, nr_seq_rtf_srtring_w);
select	ds_texto
into STRICT	ds_historico_os_w
from	tasy_conversao_rtf
where	nr_sequencia = nr_seq_rtf_srtring_w;
exception when others then
	ds_historico_os_w := 'Verificar ordem de serviço ' || to_char(nr_sequencia_p) || '.';
end;

ds_titulo_w	:= 'OS ' || to_char(nr_sequencia_p) || ' encaminhada para pós-venda';
ds_comunic_w	:= substr('A ordem de serviço ' || to_char(nr_sequencia_p) || ' foi encaminhada para sua análise.' || chr(10) || chr(13) || chr(10) || chr(13) ||
			obter_desc_expressao(508099)/*'Último histórico: '*/
 || chr(10) || chr(13) || ds_historico_os_w,1,4000);

CALL Gerar_Comunic_Padrao(
		clock_timestamp(),
		ds_titulo_w,
		ds_comunic_w,
		nm_usuario_p,
		'N',
		nm_usuario_gestor_w || ',',
		'N',
		5,
		null,
		null,
		null,
		clock_timestamp(),
		null,
		null);

Insert into man_ordem_serv_envio(
	nr_sequencia,
	nr_seq_ordem,
	dt_atualizacao,
	nm_usuario,
	dt_envio,
	ie_tipo_envio,
	ds_destino,
	ds_observacao)
values (	nextval('man_ordem_serv_envio_seq'),
	nr_sequencia_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	'I',
	nm_usuario_gestor_w,
	ds_titulo_w);

select	coalesce(substr(obter_dados_usuario_opcao(nm_usuario_gestor_w,'E'),1,255),'X')
into STRICT	ds_email_w
;

if (ie_envia_relatorio_p = 'S') then

    ds_email_relat_p := ds_email_w;

elsif (ds_email_w <> 'X') then

	begin
	ie_erro_mail_w	:= 'N';
	CALL Enviar_Email(ds_titulo_w, ds_comunic_w, null, ds_email_w, nm_usuario_p,'M');
	exception when others then
	ie_erro_mail_w	:= 's';
	end;

	if (ie_erro_mail_w = 'N') then

		Insert into man_ordem_serv_envio(
			nr_sequencia,
			nr_seq_ordem,
			dt_atualizacao,
			nm_usuario,
			dt_envio,
			ie_tipo_envio,
			ds_destino,
			ds_observacao)
		values (	nextval('man_ordem_serv_envio_seq'),
			nr_sequencia_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			'E',
			ds_email_w,
			ds_titulo_w);
		
	end if;

end if;

commit;		

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE des_enc_os_gestor_conta_relat ( nr_sequencia_p bigint, nm_usuario_p text, ie_envia_relatorio_p text default 'N', ds_email_relat_p INOUT text  DEFAULT NULL) FROM PUBLIC;

