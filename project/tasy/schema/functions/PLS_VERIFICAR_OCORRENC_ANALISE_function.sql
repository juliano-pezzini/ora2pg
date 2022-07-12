-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_verificar_ocorrenc_analise ( nr_seq_analise_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(2);
qt_ocorrencias_w		bigint;
nr_seq_analise_ocorrenc_w	bigint;
nr_seq_regra_ocorrencia_w	bigint;
ie_tipo_regra_w			varchar(10);
nr_seq_pessoa_proposta_w	bigint;
ie_pericia_medica_w		varchar(10);

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_analise_ocorrencia
	where	nr_seq_analise	= nr_seq_analise_p;


BEGIN

select	max(nr_seq_pessoa_proposta)
into STRICT	nr_seq_pessoa_proposta_w
from	pls_analise_adesao
where	nr_sequencia	= nr_seq_analise_p;

select	count(*)
into STRICT	qt_ocorrencias_w
from	pls_analise_ocorrencia
where	nr_seq_analise	= nr_seq_analise_p;

ie_retorno_w	:= 'N';

if (qt_ocorrencias_w > 0) then
	open C01;
	loop
	fetch C01 into
		nr_seq_analise_ocorrenc_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		select	nr_seq_regra_ocorrencia
		into STRICT	nr_seq_regra_ocorrencia_w
		from	pls_analise_ocorrencia
		where	nr_sequencia	= nr_seq_analise_ocorrenc_w;

		if (nr_seq_regra_ocorrencia_w IS NOT NULL AND nr_seq_regra_ocorrencia_w::text <> '') then
			select	max(ie_tipo_regra)
			into STRICT	ie_tipo_regra_w
			from	pls_regra_analise_adesao
			where	nr_sequencia	= nr_seq_regra_ocorrencia_w;

			/*Verificar se o beneficiário da análise fez uma pericia médica*/

			if (ie_tipo_regra_w = 'PM') and (ie_retorno_w = 'N') then
				ie_pericia_medica_w	:= substr(pls_proposta_obter_se_pericia(nr_seq_pessoa_proposta_w),1,1);
				if (ie_pericia_medica_w = 'N') then
					ie_retorno_w	:= 'S';
				elsif (ie_pericia_medica_w = 'S') then
					ie_retorno_w	:= 'N';
				end if;
			end if;
		end if;
		end;
	end loop;
	close C01;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_verificar_ocorrenc_analise ( nr_seq_analise_p bigint) FROM PUBLIC;
