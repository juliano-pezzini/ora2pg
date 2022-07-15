-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE get_ihc_cer ( nr_seq_claim_p ihc_claim.nr_sequencia%type, nm_usuario_p ihc_claim.nm_usuario%type) AS $body$
DECLARE

			
nr_seq_w			ihc_cer.nr_sequencia%type;
cd_certificate_w	ihc_cer.cd_certificate%type;
ds_certifying_w		ihc_cer.ds_certifying%type;
cd_certifying_w		ihc_cer.cd_certifying%type := null;
qt_inconsistencia_w	integer;
dt_issue_w			ihc_cer.dt_issue%type;
dt_from_w			ihc_cer.dt_from%type;
ds_text_w			ihc_cer.ds_text%type := null;
qt_days_w			ihc_cer.qt_days%type := null;
dt_end_w			ihc_cer.dt_end%type := null;

c01 CURSOR FOR
SELECT	a.ie_tipo_justificativa,
		a.cd_profissional,
		a.dt_justificativa,
		b.nr_account,
		a.dt_liberacao,
		a.ds_justificativa,
		a.nr_sequencia
from	paciente_justificativa a,
		ihc_claim b
where	a.nr_atendimento = b.nr_episode
and		b.nr_sequencia = nr_seq_claim_p;

cursor_w c01%rowtype;
	

BEGIN

	open c01;
	loop
	fetch c01 into cursor_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

	begin
	
		cd_certificate_w := get_eclipse_conversion('IE_TIPO_JUSTIFICATIVA', cursor_w.ie_tipo_justificativa, 'IHC', null, null, cd_certificate_w);
		
		cd_certifying_w := cursor_w.cd_profissional;
		ds_certifying_w := obter_nome_pf(cursor_w.cd_profissional);

		if (cd_certificate_w  = '3B') then
			if (coalesce(cd_certifying_w::text, '') = '' and coalesce(ds_certifying_w::text, '') = '') then
				CALL generate_inco_eclipse(cursor_w.nr_account, 1, 'Just.: '||cursor_w.nr_sequencia||'. '|| obter_desc_expressao(573711), nm_usuario_p);
			end if;
		end if;		
		
		ds_text_w := cursor_w.ds_justificativa;

		if ((cd_certificate_w = '3B' or cd_certificate_w = 'OT' or cd_certificate_w = 'C') and coalesce(ds_text_w::text, '') = '' ) then
			CALL generate_inco_eclipse(cursor_w.nr_account, 1, 'Just.: '||cursor_w.nr_sequencia||'. '|| obter_desc_expressao(635721), nm_usuario_p);	
		end if;
		
		if (coalesce(cursor_w.dt_justificativa::text, '') = '') then
			CALL generate_inco_eclipse(cursor_w.nr_account, 1, 'Just.: '||cursor_w.nr_sequencia||'. '|| obter_desc_expressao(962497), nm_usuario_p);			
		elsif (cursor_w.dt_justificativa > clock_timestamp()) then
			CALL generate_inco_eclipse(cursor_w.nr_account, 3, 'Just.: '||cursor_w.nr_sequencia||'. '|| obter_desc_expressao(962493), nm_usuario_p);
		else
			dt_issue_w := cursor_w.dt_justificativa;
		end if;
		
		if (coalesce(cursor_w.dt_liberacao::text, '') = '') then
			CALL generate_inco_eclipse(cursor_w.nr_account, 1, 'Just.: '||cursor_w.nr_sequencia||'. '|| obter_desc_expressao(580259), nm_usuario_p);
		else
			dt_from_w := cursor_w.dt_liberacao;
			dt_end_w := dt_from_w + 1; --table PACIENTE_JUSTIFICATIVA doesn't have a dt_end
			qt_days_w := 1;
		end if;
		
		select	count(nr_sequencia)
		into STRICT	qt_inconsistencia_w
		from	eclipse_inco_account
		where	nr_interno_conta = cursor_w.nr_account;
		
		if (qt_inconsistencia_w = 0 and billing_i18n_pck.get_validate_eclipse() = 'N') then

			select	nextval('ihc_cer_seq')
			into STRICT	nr_seq_w
			;

			insert into	ihc_cer(
								nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_seq_claim,
								cd_certificate,
								ds_certifying,
								cd_certifying,
								dt_issue,
								dt_from,
								qt_days,
								dt_end,
								ds_text)
						values (
								nr_seq_w,
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								nr_seq_claim_p,
								cd_certificate_w,
								ds_certifying_w,
								cd_certifying_w,
								dt_issue_w,
								dt_from_w,
								qt_days_w,
								dt_end_w,
								ds_text_w
								);
		end if;
		
	end;
	end loop;
	close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE get_ihc_cer ( nr_seq_claim_p ihc_claim.nr_sequencia%type, nm_usuario_p ihc_claim.nm_usuario%type) FROM PUBLIC;

