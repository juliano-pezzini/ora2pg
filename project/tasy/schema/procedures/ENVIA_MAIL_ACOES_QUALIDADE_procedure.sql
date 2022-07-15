-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE envia_mail_acoes_qualidade ( nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;
nr_seq_classif_w			bigint;
ds_pendencia_w			varchar(255);
dt_prev_solucao_w			timestamp;
dt_repactuada_w			timestamp;
dt_conclusao_real_w		timestamp;
nr_seq_ordem_serv_w		bigint;
ds_dano_breve_w			varchar(80);
ds_grupo_trabalho_w		varchar(255);
ie_tipo_ordem_w			integer;
nm_pessoa_resp_w			varchar(80);
--ds_acao_corretiva_w		varchar2(20000);
--ds_acao_preventiva_w		varchar2(20000);
--ds_analise_critica_w		varchar2(20000);
ds_business_review_w		varchar(20000);
--ds_technical_review_w		varchar2(20000);
--ds_acao_corretiva_vencida_w	varchar2(20000);
--ds_acao_preventiva_vencida_w	varchar2(20000);
--ds_analise_critica_vencida_w	varchar2(20000);
ds_business_review_vencida_w	varchar(20000);
--ds_technical_review_vencida_w	varchar2(20000);
ds_mensagem_w			varchar(32700);
ds_titulo_w			varchar(255);
dt_prox_dia_w			timestamp := clock_timestamp() + interval '1 days';
ds_emails_destinatarios_w		varchar(4000);
ds_emails_dest_vencidos_w		varchar(4000);
ds_email_destinatario_w		varchar(255);
cd_solicitante_w			varchar(10);
nm_usuario_solic_w			varchar(15);
cd_pessoa_resp_w			varchar(10);
cd_diretor_w			varchar(10);
nr_grupo_trabalho_w		bigint;
ds_email_dest_ger_w		varchar(255);

c01 CURSOR FOR
SELECT	distinct
	z.nr_sequencia,
	nr_seq_classif_reuniao,
	c.ds_pendencia,
	c.dt_prev_solucao,
	c.dt_repactuada,
	c.dt_conclusao_real,
	c.cd_pessoa_resp,
	(select	max(x.nr_seq_ordem)
	from	proj_ata_pendencia_os x
	where	x.nr_seq_pendencia = c.nr_sequencia) nr_seq_ordem_serv
FROM proj_ata_pendencia c, proj_ata b
LEFT OUTER JOIN ata_reuniao a ON (b.nr_seq_reuniao = a.nr_sequencia)
LEFT OUTER JOIN proj_ata_participante d ON (b.nr_sequencia = d.nr_seq_ata)
LEFT OUTER JOIN classif_reuniao z ON (a.nr_seq_classif_reuniao = z.nr_sequencia)
WHERE c.nr_seq_ata = b.nr_sequencia    and (nr_seq_classif_reuniao IS NOT NULL AND nr_seq_classif_reuniao::text <> '') and (c.cd_pessoa_resp IS NOT NULL AND c.cd_pessoa_resp::text <> '') and c.ie_status			in ('P','O');

/*
cursor	c02 is
select	a.nr_sequencia,
	a.ds_dano_breve,
	a.nr_grupo_trabalho,
	a.ie_tipo_ordem,
	a.cd_pessoa_solicitante,
	a.dt_conclusao_desejada
from	man_ordem_servico a
where	a.ie_status_ordem <> '3'
and	a.dt_fim_real is null
and	a.ie_tipo_ordem in ('8','9');
*/
BEGIN
	open c01;
	loop
	fetch c01 into	nr_sequencia_w,
			nr_seq_classif_w,
			ds_pendencia_w,
			dt_prev_solucao_w,
			dt_repactuada_w,
			dt_conclusao_real_w,
			cd_pessoa_resp_w,
			nr_seq_ordem_serv_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		ds_email_destinatario_w := '';	-- Garantia que não está pegando usuário incorreto
		select	max(a.nm_usuario)
		into STRICT	nm_pessoa_resp_w
		from	usuario a
		where	a.cd_pessoa_fisica = cd_pessoa_resp_w;

			if (nm_pessoa_resp_w IS NOT NULL AND nm_pessoa_resp_w::text <> '') then
			begin
				ds_email_destinatario_w := sis_obter_diretor(nm_pessoa_resp_w, 'M');
				ds_email_dest_ger_w := sis_obter_gerente(nm_pessoa_resp_w, 'M');

				if	((trunc(dt_prev_solucao_w) = trunc(dt_prox_dia_w)) and (coalesce(dt_repactuada_w::text, '') = '')) or (trunc(dt_repactuada_w) = trunc(dt_prox_dia_w)) then
				begin
					if	((coalesce(ds_email_destinatario_w, 'X') <> 'X') and (Obter_Se_Contido_char(ds_email_destinatario_w,ds_emails_destinatarios_w) = 'N')) then
						ds_emails_destinatarios_w := ds_emails_destinatarios_w || ',' || ds_email_destinatario_w;
					end if;
					if	((coalesce(ds_email_dest_ger_w, 'X') <> 'X') and (Obter_Se_Contido_char(ds_email_dest_ger_w,ds_emails_destinatarios_w) = 'N')) then
						ds_emails_destinatarios_w := ds_emails_destinatarios_w || ',' || ds_email_dest_ger_w;
					end if;
				end;
				elsif	((trunc(clock_timestamp()) >= trunc(dt_prev_solucao_w)) and (coalesce(dt_repactuada_w::text, '') = '')) or (trunc(dt_repactuada_w) >= trunc(dt_prox_dia_w)) then
				begin
					if	((coalesce(ds_email_destinatario_w, 'X') <> 'X') and (Obter_Se_Contido_char(ds_email_destinatario_w,ds_emails_dest_vencidos_w) = 'N')) then
						ds_emails_dest_vencidos_w := ds_emails_dest_vencidos_w || ',' || ds_email_destinatario_w;
					end if;
					if	((coalesce(ds_email_dest_ger_w, 'X') <> 'X') and (Obter_Se_Contido_char(ds_email_dest_ger_w,ds_emails_dest_vencidos_w) = 'N')) then
						ds_emails_dest_vencidos_w := ds_emails_dest_vencidos_w || ',' || ds_email_dest_ger_w;
					end if;
				end;
				end if;

				ds_grupo_trabalho_w := obter_ds_descricao_setor(obter_setor_usuario(nm_pessoa_resp_w));
/*
				if	(nr_seq_classif_w = 3) then	--  3-Análise Crítica
				begin
					if	(trunc(dt_prev_solucao_w) = trunc(dt_prox_dia_w)) then
					begin
						ds_analise_critica_w := ds_analise_critica_w || chr(13) || chr(10) ||
						'     * ' || nr_seq_ordem_serv_w || ' - ' || ds_pendencia_w || ' - ' || ds_grupo_trabalho_w;
					end;
					elsif	(trunc(sysdate) >= trunc(dt_prev_solucao_w)) then
					begin
						ds_analise_critica_vencida_w := ds_analise_critica_vencida_w || chr(13) || chr(10) ||
						'     * ' || nr_seq_ordem_serv_w || ' - ' || ds_pendencia_w || ' - ' || ds_grupo_trabalho_w;
					end;
					end if;
				end;
				end if;
*/
				if (nr_seq_classif_w = 12) then	--  12-Business Review
				begin
					if	((trunc(dt_prev_solucao_w) = trunc(dt_prox_dia_w)) and (coalesce(dt_repactuada_w::text, '') = '')) or (trunc(dt_repactuada_w) = trunc(dt_prox_dia_w)) then
					begin
						ds_business_review_w := ds_business_review_w || chr(13) || chr(10) ||
						'     * ' || nr_seq_ordem_serv_w || ' - ' || ds_pendencia_w || ' - ' || ds_grupo_trabalho_w;
					end;
					elsif	((trunc(clock_timestamp()) >= trunc(dt_prev_solucao_w)) and (coalesce(dt_repactuada_w::text, '') = '')) or (trunc(dt_repactuada_w) >= trunc(dt_prox_dia_w)) then
					begin
						ds_business_review_vencida_w := ds_business_review_vencida_w || chr(13) || chr(10) ||
						'     * ' || nr_seq_ordem_serv_w || ' - ' || ds_pendencia_w || ' - ' || ds_grupo_trabalho_w;
					end;
					end if;
				end;
				end if;

/*
				elsif	(nr_seq_classif_w = 13) then	--  13-Technical Review
				begin
					if	(trunc(dt_prev_solucao_w) = trunc(dt_prox_dia_w)) then
					begin
						ds_technical_review_w := ds_technical_review_w || chr(13) || chr(10) ||
						'     * ' || nr_seq_ordem_serv_w || ' - ' || ds_pendencia_w || ' - ' || ds_grupo_trabalho_w;
					end;
					elsif	(trunc(sysdate) >= trunc(dt_prev_solucao_w)) then
					begin
						ds_technical_review_vencida_w := ds_technical_review_vencida_w || chr(13) || chr(10) ||
						'     * ' || nr_seq_ordem_serv_w || ' - ' || ds_pendencia_w || ' - ' || ds_grupo_trabalho_w;
					end;
					end if;
				end;
				end if;
				*/
			end;
			end if;
		end;
	end loop;
	close c01;

/*
	open c02;
	loop
	fetch c02 into	nr_sequencia_w,
			ds_dano_breve_w,
			nr_grupo_trabalho_w,
			ie_tipo_ordem_w,
			cd_solicitante_w,
			dt_prev_solucao_w;
	exit when c02%notfound;
		begin
			ds_email_destinatario_w := '';
			select	max(a.ds_grupo_trabalho)
			into	ds_grupo_trabalho_w
			from	man_grupo_trabalho a
			where	a.nr_sequencia = nr_grupo_trabalho_w;

			select	max(a.nm_usuario)
			into	nm_usuario_solic_w
			from	usuario a
			where	a.cd_pessoa_fisica = cd_solicitante_w;

			if (nm_usuario_solic_w is not null) then
			begin
				ds_email_destinatario_w := sis_obter_diretor(nm_usuario_solic_w, 'M');
				ds_email_dest_ger_w := sis_obter_gerente(nm_usuario_solic_w, 'M');
			end;
			end if;

			if	(trunc(dt_prev_solucao_w) = trunc(dt_prox_dia_w)) then
			begin
				if	((nvl(ds_email_destinatario_w, 'X') <> 'X') and
					(Obter_Se_Contido_char(ds_email_destinatario_w,ds_emails_destinatarios_w) = 'N')) then
					ds_emails_destinatarios_w := ds_emails_destinatarios_w || ',' || ds_email_destinatario_w;
				end if;
				if	((nvl(ds_email_dest_ger_w, 'X') <> 'X') and
					(Obter_Se_Contido_char(ds_email_dest_ger_w,ds_emails_destinatarios_w) = 'N')) then
					ds_emails_destinatarios_w := ds_emails_destinatarios_w || ',' || ds_email_dest_ger_w;
				end if;
			end;
			elsif	(trunc(sysdate) >= trunc(dt_prev_solucao_w)) then
			begin
				if	((nvl(ds_email_destinatario_w,'X') <> 'X') and
					(Obter_Se_Contido_char(ds_email_destinatario_w,ds_emails_dest_vencidos_w) = 'N')) then
					ds_emails_dest_vencidos_w := ds_emails_dest_vencidos_w || ',' || ds_email_destinatario_w;
				end if;
				if	((nvl(ds_email_dest_ger_w,'X') <> 'X') and
					(Obter_Se_Contido_char(ds_email_dest_ger_w,ds_emails_dest_vencidos_w) = 'N')) then
					ds_emails_dest_vencidos_w := ds_emails_dest_vencidos_w || ',' || ds_email_dest_ger_w;
				end if;
			end;
			end if;

			if	(ie_tipo_ordem_w = 8) then	--  8-Ação preventiva
			begin
				if	(trunc(dt_prev_solucao_w) = trunc(dt_prox_dia_w)) then
				begin
					ds_acao_preventiva_w := ds_acao_preventiva_w || chr(13) || chr(10) ||
					'     * ' || nr_sequencia_w || ' - ' || ds_dano_breve_w || ' - ' || ds_grupo_trabalho_w;
				end;
				elsif	(trunc(sysdate) >= trunc(dt_prev_solucao_w)) then
				begin
					ds_acao_preventiva_vencida_w := ds_acao_preventiva_w || chr(13) || chr(10) ||
					'     * ' || nr_sequencia_w || ' - ' || ds_dano_breve_w || ' - ' || ds_grupo_trabalho_w;
				end;
				end if;
			end;
			elsif	(ie_tipo_ordem_w = 9) then	--  9-Ação corretiva
			begin
				if	(trunc(dt_prev_solucao_w) = trunc(dt_prox_dia_w)) then
				begin
					ds_acao_corretiva_w := ds_acao_corretiva_w || chr(13) || chr(10) ||
					'     * ' || nr_sequencia_w || ' - ' || ds_dano_breve_w || ' - ' || ds_grupo_trabalho_w;
				end;
				elsif	(trunc(sysdate) >= trunc(dt_prev_solucao_w)) then
				begin
					ds_acao_corretiva_vencida_w := substr(ds_acao_corretiva_vencida_w || chr(13) || chr(10) ||
					'     * ' || nr_sequencia_w || ' - ' || ds_dano_breve_w || ' - ' || ds_grupo_trabalho_w,1,20000);
				end;
				end if;
			end;
			end if;
		end;
	end loop;
	close c02;
*/
	-- Tratativa das mensagens Que irão vencer sysdate + 1
	ds_titulo_w   := 'Ações pendentes com vencimento para : ' || to_char(dt_prox_dia_w,'dd/mm/yyyy');
	ds_mensagem_w := 'Favor verificar as ações com seus responsáveis para solução das mesmas.' || chr(13) || chr(10);

/*
	if	(nvl(ds_acao_corretiva_w,'X') <> 'X') then
		begin
		ds_acao_corretiva_w := 'Ação corretiva: ' || chr(13) || chr(10) || ds_acao_corretiva_w || chr(13) || chr(10);
		ds_mensagem_w := substr((ds_mensagem_w || ds_acao_corretiva_w),1,35000);
		end;
	end if;
	if	(nvl(ds_acao_preventiva_w,'X') <> 'X') then
		begin
		ds_acao_preventiva_w := chr(13) || chr(10) || 'Ação preventiva: ' || chr(13) || chr(10) || ds_acao_preventiva_w || chr(13) || chr(10);
		ds_mensagem_w := substr((ds_mensagem_w || ds_acao_preventiva_w),1,35000);
		end;
	end if;
	if	(nvl(ds_analise_critica_w,'X') <> 'X') then
		begin
		ds_analise_critica_w := chr(13) || chr(10) || 'Análise crítica: ' || chr(13) || chr(10) || ds_analise_critica_w || chr(13) || chr(10);
		ds_mensagem_w := substr((ds_mensagem_w || ds_analise_critica_w),1,35000);
		end;
	end if;
*/
	if (coalesce(ds_business_review_w,'X') <> 'X') then
		begin
		ds_business_review_w := chr(13) || chr(10) || 'Business review: ' || chr(13) || chr(10) || ds_business_review_w || chr(13) || chr(10);
		ds_mensagem_w := substr((ds_mensagem_w || ds_business_review_w),1,35000);
		end;
	end if;

/*
	if	(nvl(ds_technical_review_w,'X') <> 'X') then
		begin
		ds_technical_review_w := chr(13) || chr(10) || 'Technical review: ' || chr(13) || chr(10) || ds_technical_review_w || chr(13) || chr(10);
		ds_mensagem_w := substr((ds_mensagem_w || ds_technical_review_w),1,35000);
		end;
	end if;
*/
	-- Ajuste do destinatário
	ds_emails_destinatarios_w := substr(ds_emails_destinatarios_w, 2);
	ds_emails_destinatarios_w := replace(ds_emails_destinatarios_w,',',';');
	ds_emails_destinatarios_w := replace(ds_emails_destinatarios_w,';support.informatics@philips.com','');

	ds_emails_dest_vencidos_w := substr(ds_emails_dest_vencidos_w, 2);
	ds_emails_dest_vencidos_w := replace(ds_emails_dest_vencidos_w,',',';');
	ds_emails_dest_vencidos_w := replace(ds_emails_dest_vencidos_w,';support.informatics@philips.com','');

	if (coalesce(ds_business_review_w,'X') <> 'X') then
	begin
		if (ds_emails_destinatarios_w <> '') then
		begin
			CALL Enviar_Email(	ds_titulo_w,
					ds_mensagem_w,
					'support.informatics@philips.com',
					ds_emails_destinatarios_w,
					'TASY','M');
		end;
		end if;
	end;
	end if;

	-- tratativa das mensagens que estão vencidas
	ds_titulo_w   := 'Ações atrasadas';
	ds_mensagem_w := 'Favor verificar as ações com seus responsáveis para solução das mesmas.'  || chr(13) || chr(10) ||
			 'OBS: Repactuar data junto ao departamento de Qualidade.' || chr(13) || chr(10);

/*
	 if	(nvl(ds_acao_corretiva_vencida_w,'X') <> 'X') then
		begin
		ds_acao_corretiva_vencida_w := substr(('Ação corretiva: ' || chr(13) || chr(10) || ds_acao_corretiva_vencida_w || chr(13) || chr(10)),1,20000);
		ds_mensagem_w := substr((ds_mensagem_w || ds_acao_corretiva_vencida_w),1,35000);
		end;
	end if;
	if	(nvl(ds_acao_preventiva_vencida_w,'X') <> 'X') then
		begin
		ds_acao_preventiva_vencida_w := chr(13) || chr(10) || 'Ação preventiva: ' || chr(13) || chr(10) || ds_acao_preventiva_vencida_w || chr(13) || chr(10);
		ds_mensagem_w := substr((ds_mensagem_w || ds_acao_preventiva_vencida_w),1,35000);
		end;
	end if;
	if	(nvl(ds_analise_critica_vencida_w,'X') <> 'X') then
		begin
		ds_analise_critica_vencida_w := chr(13) || chr(10) || 'Análise crítica: ' || chr(13) || chr(10) || ds_analise_critica_vencida_w || chr(13) || chr(10);
		ds_mensagem_w := substr((ds_mensagem_w || ds_analise_critica_vencida_w),1,35000);
		end;
	end if;
*/
	if (coalesce(ds_business_review_vencida_w,'X') <> 'X') then
		begin
		ds_business_review_vencida_w := chr(13) || chr(10) || 'Business review: ' || chr(13) || chr(10) || ds_business_review_vencida_w || chr(13) || chr(10);
		ds_mensagem_w := substr((ds_mensagem_w || ds_business_review_vencida_w),1,35000);
		end;
	end if;

/*
	if	(nvl(ds_technical_review_vencida_w,'X') <> 'X') then
		begin
		ds_technical_review_vencida_w := chr(13) || chr(10) || 'Technical review: ' || chr(13) || chr(10) || ds_technical_review_vencida_w || chr(13) || chr(10);
		ds_mensagem_w := substr((ds_mensagem_w || ds_technical_review_vencida_w),1,35000);
		end;
	end if;
*/
	if (coalesce(ds_business_review_w,'X') <> 'X') then
	begin
		if (coalesce(ds_emails_dest_vencidos_w,'X') <> 'X') then
		begin
			CALL Enviar_Email(	ds_titulo_w,
					ds_mensagem_w,
					'support.informatics@philips.com',
					ds_emails_dest_vencidos_w,
					'TASY','M');
		end;
		end if;
	end;
	end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE envia_mail_acoes_qualidade ( nm_usuario_p text) FROM PUBLIC;

