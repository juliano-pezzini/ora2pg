-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_regra_partic ( nr_seq_conta_proc_p bigint, nr_seq_regra_partic_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


vl_retorno_w			varchar(2)	:= 'N';
qt_participantes_w		bigint	:= 0;
nr_seq_prestador_w		bigint;
cd_medico_w			varchar(10);
nr_seq_grau_partic_w		bigint;
nr_seq_grupo_prestador_w	bigint;
ie_se_grupo_prestador_w		varchar(2);
ie_participante_duplic_w	varchar(1);
qt_registro_w			bigint;


/*Tratar o grupo do prestador*/

/*
	RETORNA 'S', SE AO MENOS DOIS PARTICIPANTES SE ENCAIXAREM NAS REGRAS.
	No momento esta function somente verifica se existe ao menos 2 participantes que se encaixam na regra.
	Futururamente deverá ser implementado o retorno do participante em especifica, para poder gerar ocorrência para o mesmo.
*/
C01 CURSOR FOR  --cursor dos participantes do procedimento
	SELECT	nr_seq_prestador,
		cd_medico,
		nr_seq_grau_partic
	from 	pls_proc_participante
	where	nr_seq_conta_proc 	= coalesce(nr_seq_conta_proc_p,0);

C02 CURSOR FOR  --cursor das regras
	SELECT	a.nr_seq_grupo_prestador,
		a.ie_participante_duplic
	from 	pls_itens_regra_partic		a,
		pls_oc_regra_participante	b
	where	a.nr_seq_regra = b.nr_sequencia
	and	b.nr_sequencia = coalesce(nr_seq_regra_partic_p,0)
	and	((coalesce(a.nr_seq_prestador::text, '') = '') or (a.nr_seq_prestador = nr_seq_prestador_w))
	and	((coalesce(a.nr_seq_grau_partic::text, '') = '') or (a.nr_seq_grau_partic = nr_seq_grau_partic_w))
	and	b.ie_situacao = 'A'
	and	a.ie_situacao = 'A';


BEGIN

qt_participantes_w	:= 0;
open C01; -- participantes da conta
loop
fetch C01 into
	nr_seq_prestador_w,
	cd_medico_w,
	nr_seq_grau_partic_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	open C02; -- regra participantes
	loop
	fetch C02 into
		nr_seq_grupo_prestador_w,
		ie_participante_duplic_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (ie_participante_duplic_w = 'S') then
			select	count(*)
			into STRICT	qt_registro_w
			from	pls_proc_participante
			where	nr_seq_conta_proc	= coalesce(nr_seq_conta_proc_p,0)
			and	((nr_seq_prestador = nr_seq_prestador_w) or (cd_medico = cd_medico_w));

			if (qt_registro_w > 1) then
				qt_participantes_w	:= qt_participantes_w + 1;/*Se encaixar em algum participante da regra, incrementa*/
			end if;
		else
			qt_participantes_w	:= qt_participantes_w + 1;/*Se encaixar em algum participante da regra, incrementa*/
		end if;

		-- se existe regra por grupo prestador é verificado se o prestador pertence ao grupo infromado na regra.
		if (coalesce(nr_seq_grupo_prestador_w,0) > 0) then
			ie_se_grupo_prestador_w	:= pls_se_grupo_preco_prestador(nr_seq_grupo_prestador_w,nr_seq_prestador_w, null);

			if (ie_se_grupo_prestador_w = 'N') then
				qt_participantes_w	:= qt_participantes_w -1;--se a regra esta informada, mas o participante do procedimento nao faz parte do grupo, decrementa
			end if;
		end if;
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;

if (qt_participantes_w >1) then
	vl_retorno_w	:= 'S';
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_regra_partic ( nr_seq_conta_proc_p bigint, nr_seq_regra_partic_p bigint, nm_usuario_p text) FROM PUBLIC;
