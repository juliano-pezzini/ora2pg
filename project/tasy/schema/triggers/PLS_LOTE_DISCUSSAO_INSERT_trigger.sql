-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_lote_discussao_insert ON pls_lote_discussao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_lote_discussao_insert() RETURNS trigger AS $BODY$
declare
ie_status_w		pls_lote_contestacao.ie_status%type := 'D'; -- Contestação Em discussão
nr_seq_pls_fatura_w	pls_lote_contestacao.nr_seq_pls_fatura%type;
nr_seq_ptu_fatura_w	pls_lote_contestacao.nr_seq_ptu_fatura%type;
qt_integral_w		integer;

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S')  then
	select	max(nr_seq_pls_fatura),
		max(nr_seq_ptu_fatura)
	into STRICT	nr_seq_pls_fatura_w,
		nr_seq_ptu_fatura_w
	from	pls_lote_contestacao
	where	nr_sequencia	= NEW.nr_seq_lote_contest;

	-- No momento que importa um A550 de faturamento e gerar discussão - OS 605067
	-- Contestação da OPS - Faturamento
	if (nr_seq_pls_fatura_w is not null) then
		if (NEW.ie_status = 'A') then
			-- Contestação Enviada/Recebida
			ie_status_w := 'E';
		end if;

		-- Quando incluir uma nova discussão, mudar o status do lote de contestação caso esteja em aberto
		update	pls_lote_contestacao
		set	ie_status	= ie_status_w,
			nm_usuario	= NEW.nm_usuario,
			dt_atualizacao	= NEW.dt_atualizacao
		where	nr_sequencia	= NEW.nr_seq_lote_contest
		and	ie_status	= 'E';

		-- compatibilidade com a rotina de alteração de status, se chamar ela aqui pode gerar o erro de mutante
		if (ie_status_w = 'C') then

			update	pls_contestacao_discussao
			set	ie_status	= 'E',
				nm_usuario	= NEW.nm_usuario,
				dt_atualizacao	= LOCALTIMESTAMP
			where	nr_seq_lote	= NEW.nr_sequencia;
		end if;
	end if;

	-- Contestação da OPS - Contas de Intercâmbio (A500)
	if (nr_seq_ptu_fatura_w is not null) then
		qt_integral_w := 0;
		if (NEW.ie_tipo_arquivo in (5,6,7,8,9)) then
			-- Verificar se o decurso de prazo é complementar ou parcial
			if (NEW.ie_tipo_arquivo in (9)) then
				-- Se existir ao menos um questionamento com tipo de acordo 10, então a discussão deverá ser concluida
				-- Feito na OS 909630 - dia 16-03-2017
				select	count(1)
				into STRICT	qt_integral_w
				from	ptu_camara_contestacao	c,
					ptu_questionamento	q
				where	c.nr_sequencia		= q.nr_seq_contestacao
				and	c.nr_seq_lote_contest	= NEW.nr_seq_lote_contest
				and	q.ie_tipo_acordo	in ('10', '15'); -- Encerrado pelo administrador
			end if;

			-- Contestação Concluida
			if (qt_integral_w > 0) then
				ie_status_w := 'C';
			end if;
		end if;

		update	pls_lote_contestacao
		set	ie_status	= ie_status_w,
			nm_usuario	= NEW.nm_usuario,
			dt_atualizacao	= NEW.dt_atualizacao
		where	nr_sequencia	= NEW.nr_seq_lote_contest
		and	ie_status	in ('E','D');


		-- compatibilidade com a rotina de alteração de status, se chamar ela aqui pode gerar o erro de mutante
		if (ie_status_w = 'C') then

			update	pls_contestacao_discussao
			set	ie_status	= 'E',
				nm_usuario	= NEW.nm_usuario,
				dt_atualizacao	= LOCALTIMESTAMP
			where	nr_seq_lote	= NEW.nr_sequencia;
		end if;
	end if;

end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_lote_discussao_insert() FROM PUBLIC;

CREATE TRIGGER pls_lote_discussao_insert
	AFTER INSERT ON pls_lote_discussao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_lote_discussao_insert();
