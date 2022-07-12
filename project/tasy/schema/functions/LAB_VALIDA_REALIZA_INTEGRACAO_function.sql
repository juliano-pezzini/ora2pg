-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_valida_realiza_integracao (nr_prescricao_p prescr_procedimento.nr_prescricao%type, nr_sequencia_p prescr_procedimento.nr_sequencia%TYPE) RETURNS varchar AS $body$
DECLARE


ie_integrar_w       lab_regra_realiza_integra.ie_integrar%TYPE;



BEGIN
    if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '' AND nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	
		select	CASE WHEN count(*)=0 THEN  'S'  ELSE 'N' END
		into STRICT	ie_integrar_w
		from	LAB_REGRA_REALIZA_INTEGRA;
		
		if (ie_integrar_w = 'N') then
			select 	ie_integrar
			into STRICT 	ie_integrar_w
			from (SELECT  a.ie_tipo_atendimento, a.cd_estabelecimento, a.ie_autorizacao, coalesce(a.ie_integrar,'S') ie_integrar
					from	LAB_REGRA_REALIZA_INTEGRA a,
							prescr_procedimento b,
							atendimento_paciente c,
							prescr_medica d
					where   coalesce(a.cd_estabelecimento,d.cd_estabelecimento)     = d.cd_estabelecimento
					and     coalesce(a.IE_TIPO_ATENDIMENTO,c.IE_TIPO_ATENDIMENTO)	= c.IE_TIPO_ATENDIMENTO
					and		coalesce(a.ie_autorizacao,b.ie_autorizacao,'L')		    = coalesce(b.ie_autorizacao,'L')
					and		c.nr_atendimento		                                = d.nr_atendimento
					and     d.nr_prescricao                                         = b.nr_prescricao
					and     d.nr_prescricao                                         = nr_prescricao_p
					and     b.nr_sequencia                                          = nr_sequencia_p
					order by 1,2,3 ) alias6 LIMIT 1;
		end if;
    EXCEPTION
            WHEN no_data_found THEN
				
                return coalesce(ie_integrar_w,'N');
				
			WHEN OTHERS THEN
			
				return 'S';

    end;
    end if;
	
return coalesce(ie_integrar_w,'S');
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_valida_realiza_integracao (nr_prescricao_p prescr_procedimento.nr_prescricao%type, nr_sequencia_p prescr_procedimento.nr_sequencia%TYPE) FROM PUBLIC;

