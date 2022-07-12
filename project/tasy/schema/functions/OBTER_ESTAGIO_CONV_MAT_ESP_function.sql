-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estagio_conv_mat_esp ( nr_seq_agenda_p bigint, cd_convenio_p bigint, opcao_p text) RETURNS varchar AS $body$
DECLARE


--  opcao_p
--  C -  Estágio -  Autorização convênio
-- M -  Estágio autorização  -  Autorização de materiais especiais
ds_retorno_w varchar(255);



BEGIN

if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then

	if (opcao_p = 'C') then

		select max(substr(obter_descricao_padrao('ESTAGIO_AUTORIZACAO', 'DS_ESTAGIO', a.nr_seq_estagio),1,254))
		into STRICT   ds_retorno_w
		FROM   autorizacao_convenio a,
		       estagio_autorizacao b
		WHERE  a.nr_seq_agenda = nr_seq_agenda_p
		AND    a.cd_convenio   = cd_convenio_p
		AND    a.nr_seq_estagio = b.nr_sequencia
		AND    b.ie_interno <> 70
		AND    a.IE_TIPO_AUTORIZACAO = 3
		and    DT_AUTORIZACAO = (SELECT max(DT_AUTORIZACAO)
					FROM   autorizacao_convenio a,
					        estagio_autorizacao b
					WHERE  a.nr_seq_agenda = nr_seq_agenda_p
					AND    a.cd_convenio   = cd_convenio_p
					AND    a.nr_seq_estagio = b.nr_sequencia
					AND    b.ie_interno <> 70
					AND    a.IE_TIPO_AUTORIZACAO = 3);

	elsif (opcao_p = 'M') then

		select max(substr(obter_valor_dominio(3116,IE_ESTAGIO_AUTOR),1,255))
		into STRICT   ds_retorno_w
		from   AUTORIZACAO_CIRURGIA
		where  nr_seq_agenda = nr_seq_agenda_p
		and    ie_estagio_autor <> 6;

	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estagio_conv_mat_esp ( nr_seq_agenda_p bigint, cd_convenio_p bigint, opcao_p text) FROM PUBLIC;
