-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_se_regra_particip ( nr_seq_conta_proc_p bigint, nr_seq_regra_partic_p bigint, nm_usuario_p text, ie_retorno_p INOUT text,	--Se uma das regras é válida para ao menos um dos participante
 nr_seq_ocorrencia_p bigint) AS $body$
DECLARE


/*Lógica da rotina:
	É necessário que ao menos uma das regras existentes no mesmo grupo/agrupador sejam seguidas para que seja gerada ocorrência.
	Caso ao menos uma das regras existentes no mesmo grupo/agrupador em cada grupo/agrupador forem seguidas é gerada ocorrência para os participantes que seguem as regras marcadas como "Ocorrência"
   Lógica vista com o Analista Roni (Unimed Rio Preto) e Paulo Rosa.
*/
nr_seq_agrupador_w		bigint;
nr_seq_regra_w			bigint;
nr_seq_prestador_w		bigint;
nr_seq_grupo_prestador_w	bigint;
nr_seq_grau_partic_w		bigint;
nr_seq_partic_w			bigint;

ie_participante_duplic_w	varchar(1);
ie_gerar_ocorrencia_w		varchar(1);
nr_seq_proc_referencia_w	bigint;
qt_participantes_w		bigint;
nr_seq_prestador_exec_w		bigint;
contador			smallint := 0;
ie_encontro_partic_w		varchar(1) := 'N';

ie_partic_valido_w		varchar(1)	:= 'N';
ie_prest_exec_valido_w		varchar(1)	:= 'N';
nr_seq_prest_partic_w		bigint;
ie_grupo_prestador_w		varchar(1);
cd_medico_partic_w		varchar(10);
qt_partic_duplic_w		bigint;
qt_participante_w		bigint;
nr_seq_agrup_analise_w		bigint;
C01 CURSOR FOR  --Obter os agrupadores/grupos
	SELECT	x.nr_sequencia
	from	pls_oc_regra_grupo_partic x
	where	x.nr_seq_regra_partic = nr_seq_regra_partic_p;


C02 CURSOR FOR  --Obter os regras do agrupador
	SELECT	nr_sequencia,
		nr_seq_prestador,
		nr_seq_grupo_prestador,
		nr_seq_grau_partic,
		coalesce(ie_participante_duplic,'N'),
		coalesce(ie_ocorrencia,'N')
	from	pls_itens_regra_partic
	where	nr_seq_grupo_regra = nr_seq_agrupador_w
	and	ie_situacao = 'A';

C03 CURSOR FOR 	--Obter os participantes que se encaixam na regra
	SELECT	a.nr_sequencia,
		a.cd_medico,
		a.nr_seq_prestador
	from	pls_proc_participante 	a,
		pls_conta_proc 		b
	where	a.nr_seq_conta_proc 	= b.nr_sequencia
	and (a.ie_status <> 'C' or coalesce(a.ie_status::text, '') = '')
	and	b.nr_seq_proc_ref = nr_seq_conta_proc_p
	and	((coalesce(nr_seq_prestador_w::text, '') = '') 	    		or (a.nr_seq_prestador  	= nr_seq_prestador_w))
	and	((coalesce(nr_seq_grau_partic_w::text, '') = '')     		or (a.nr_seq_grau_partic  	= nr_seq_grau_partic_w))
	--and	((nr_seq_grupo_prestador_w is null) 		or (pls_se_grupo_preco_prestador(nr_seq_grupo_prestador_w, a.nr_seq_prestador, null) = 'S'))
	
union all

	SELECT	a.nr_sequencia,
		a.cd_medico,
		a.nr_seq_prestador
	from	pls_proc_participante 	a,
		pls_conta_proc 		b
	where	a.nr_seq_conta_proc 	= b.nr_sequencia
	and (a.ie_status <> 'C' or coalesce(a.ie_status::text, '') = '')
	and	b.nr_sequencia = nr_seq_conta_proc_p
	and	((coalesce(nr_seq_prestador_w::text, '') = '') 	    		or (a.nr_seq_prestador  	= nr_seq_prestador_w))
	and	((coalesce(nr_seq_grau_partic_w::text, '') = '')     		or (a.nr_seq_grau_partic  	= nr_seq_grau_partic_w));
	--and	((nr_seq_grupo_prestador_w is null) 		or (pls_se_grupo_preco_prestador(nr_seq_grupo_prestador_w, a.nr_seq_prestador, null) = 'S'));
C04 CURSOR FOR  --Obter todas as regras que devem gerar ocorrência para aplica-las nos participantes
	SELECT	a.nr_sequencia,
		a.nr_seq_prestador,
		a.nr_seq_grupo_prestador,
		a.nr_seq_grau_partic,
		a.ie_participante_duplic
	from	pls_itens_regra_partic a,
		pls_oc_regra_grupo_partic b
	where	a.nr_seq_grupo_regra  = b.nr_sequencia
	and	b.nr_seq_regra_partic = nr_seq_regra_partic_p
	and	a.ie_situacao  = 'A'
	and	a.ie_ocorrencia = 'S';


BEGIN

select	count(1)
into STRICT	qt_participante_w
from	pls_conta_proc	a,
	pls_conta	b
where	a.nr_seq_conta	= b.nr_sequencia
and	a.nr_sequencia 	= nr_seq_conta_proc_p
and	exists	( 	SELECT	1
			from	pls_oc_regra_grupo_partic x,
				pls_itens_regra_partic y
			where	x.nr_seq_regra_partic = nr_seq_regra_partic_p
			and	y.nr_seq_grupo_regra = x.nr_sequencia
			and	((y.nr_seq_grau_partic = b.nr_seq_grau_partic) or (coalesce(y.nr_seq_grau_partic::text, '') = ''))
			and	((coalesce(y.nr_seq_prestador::text, '') = '') or (y.nr_seq_prestador = b.nr_seq_prestador_exec))
			and	((coalesce(y.ie_ocorrencia::text, '') = '') or (y.ie_ocorrencia = 'S')));

ie_retorno_p := 'N';



if (qt_participante_w = 0 ) then
	goto final2;
end if;

select	max(nr_seq_agrup_analise)
into STRICT	nr_seq_agrup_analise_w
from	pls_conta_proc
where	nr_sequencia = nr_seq_conta_proc_p;

select 	count(1)
into STRICT  	qt_participantes_w
from 	pls_proc_participante
where	nr_seq_conta_proc 	=  nr_seq_conta_proc_p
and (ie_status <> 'C' or coalesce(ie_status::text, '') = '');

open C01;
loop
fetch C01 into
	nr_seq_agrupador_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	contador :=0;
	ie_encontro_partic_w := 'N';

	open C02;
	loop
	fetch C02 into
		nr_seq_regra_w,
		nr_seq_prestador_w,
		nr_seq_grupo_prestador_w,
		nr_seq_grau_partic_w,
		ie_participante_duplic_w,
		ie_gerar_ocorrencia_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		ie_partic_valido_w	:= 'N';
		ie_prest_exec_valido_w	:= 'N';
		/*Deve haver mais de uma participante de um precedimento para a regra ser aplicavel*/

		if (coalesce(qt_participantes_w,0) = 0) then

			select	max(a.nr_seq_prestador_exec)
			into STRICT	nr_seq_prestador_exec_w
			from	pls_conta 	a,
				pls_conta_proc 	b
			where	a.nr_sequencia	= b.nr_seq_conta
			and	((b.nr_sequencia = nr_seq_conta_proc_p) or (b.nr_seq_agrup_analise = nr_seq_agrup_analise_w))
			and	((coalesce(nr_seq_prestador_w::text, '') = '') 	    		or (a.nr_seq_prestador_exec  	= nr_seq_prestador_w))
			and	((coalesce(nr_seq_grau_partic_w::text, '') = '')     		or (a.nr_seq_grau_partic  	= nr_seq_grau_partic_w))
			--and	((nr_seq_grupo_prestador_w is null) 		or (pls_se_grupo_preco_prestador(nr_seq_grupo_prestador_w, a.nr_seq_prestador_exec, null) = 'S'))
			and	(((coalesce(ie_participante_duplic_w::text, '') = '') or (ie_participante_duplic_w = 'N'))
										or ((SELECT	count(1)
										     from	pls_conta	 	x,
												pls_conta_proc 		y
										     where	x.nr_sequencia 	= y.nr_seq_conta
										     and	((y.nr_sequencia = nr_seq_conta_proc_p) or (y.nr_seq_agrup_analise = nr_seq_agrup_analise_w))
										     and (x.cd_medico_executor	= a.cd_medico_executor
										     or	 	x.nr_seq_prestador_exec	= a.nr_seq_prestador_exec)) > 1));
		else
			open C03;
			loop
			fetch C03 into
				nr_seq_partic_w,
				cd_medico_partic_w,
				nr_seq_prest_partic_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				ie_grupo_prestador_w	:= 'S';

				if (nr_seq_grupo_prestador_w > 0) then
					ie_grupo_prestador_w	:= pls_se_grupo_preco_prestador(nr_seq_grupo_prestador_w, nr_seq_prest_partic_w, null);
				end if;

				if (ie_grupo_prestador_w = 'S') then
					if (ie_participante_duplic_w = 'S') then
						select	sum(qt_partic)
						into STRICT	qt_partic_duplic_w
						from (SELECT	count(1) qt_partic
						from	pls_proc_participante 	x,
							pls_conta_proc 		y
						where	x.nr_seq_conta_proc 	= y.nr_sequencia
						and (x.ie_status	<> 'C' or coalesce(x.ie_status::text, '') = '')
						and	y.nr_seq_proc_ref = nr_seq_conta_proc_p
						and (x.cd_medico 		= cd_medico_partic_w
							or x.nr_seq_prestador 	= nr_seq_prest_partic_w)
						
union all

						SELECT	count(1) qt_partic
						from	pls_proc_participante 	x,
							pls_conta_proc 		y
						where	x.nr_seq_conta_proc 	= y.nr_sequencia
						and (x.ie_status	<> 'C' or coalesce(x.ie_status::text, '') = '')
						and	y.nr_sequencia = nr_seq_conta_proc_p
						and (x.cd_medico 		= cd_medico_partic_w
							or x.nr_seq_prestador 	= nr_seq_prest_partic_w)
						) alias11;

						if (qt_partic_duplic_w > 1) then
							ie_partic_valido_w	:= 'S';
						end if;
					else
						ie_partic_valido_w	:= 'S';
					end if;
				end if;
			end loop;
			close C03;
		end if;

		if (ie_partic_valido_w = 'S') or (coalesce(nr_seq_prestador_exec_w,0) > 0)then
			ie_encontro_partic_w := 'S';
			goto final;
		end if;
		/*Se esta regra foi seguida (FOI ACHADO UM PARTICIPANTE NO ATO QUE SEGUE O ESTIPULADO NA REGRA ) o agrupamento é válido. Passa-se para o próximo agrupamento*/

		end;
	end loop;
	close C02;

	if (coalesce(ie_encontro_partic_w,'N') = 'N') then
		ie_retorno_p := 'N';
		goto final2;
	end if;

	<<final>>
	if (C02%ISOPEN) then
		close C02;
	end if;
	end;
end loop;
close C01;
/*Se chegou neste ponto todas as regras do agrupamento não são válidas e  não podem gerar ocorrência, não é mais necessário verificar os outros agrupamentos.*/

if (coalesce(ie_encontro_partic_w,'N') = 'N') then
	ie_retorno_p := 'N';
	goto final2;
end if;

if (C02%ISOPEN) then
	close C02;
end if;
if (C01%ISOPEN) then
	close C01;
end if;

if (coalesce(nr_seq_prestador_exec_w,0) > 0) or (coalesce(nr_seq_partic_w,0) > 0) then

	ie_retorno_p := 'S';

end if;
/*Fechar o cursor se este estiver aberto*/

/*Se chegou neste ponto todas os agrupamentos são válidas. Portanto gera-se a ocorrência*/

open C04;
loop
fetch C04 into
	nr_seq_regra_w,
	nr_seq_prestador_w,
	nr_seq_grupo_prestador_w,
	nr_seq_grau_partic_w,
	ie_participante_duplic_w;
EXIT WHEN NOT FOUND; /* apply on C04 */
	begin

	open C03;
	loop
	fetch C03 into
		nr_seq_partic_w,
		cd_medico_partic_w,
		nr_seq_prest_partic_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		ie_grupo_prestador_w	:= 'S';

		if (nr_seq_grupo_prestador_w > 0) then
			ie_grupo_prestador_w	:= pls_se_grupo_preco_prestador(nr_seq_grupo_prestador_w, nr_seq_prest_partic_w, null);
		end if;

		if (ie_grupo_prestador_w = 'S') then
			if (ie_participante_duplic_w = 'S') then
				select	sum(qt_partic)
				into STRICT	qt_partic_duplic_w
				from (SELECT	count(1) qt_partic
				from	pls_proc_participante 	x,
					pls_conta_proc 		y
				where	x.nr_seq_conta_proc 	= y.nr_sequencia
				and (x.ie_status	<> 'C' or coalesce(x.ie_status::text, '') = '')
				and	y.nr_seq_proc_ref = nr_seq_conta_proc_p
				and (x.cd_medico 		= cd_medico_partic_w
					or x.nr_seq_prestador 	= nr_seq_prest_partic_w)
				
union all

				SELECT	count(1) qt_partic
				from	pls_proc_participante 	x,
					pls_conta_proc 		y
				where	x.nr_seq_conta_proc 	= y.nr_sequencia
				and (x.ie_status	<> 'C' or coalesce(x.ie_status::text, '') = '')
				and	y.nr_sequencia = nr_seq_conta_proc_p
				and (x.cd_medico 		= cd_medico_partic_w
					or x.nr_seq_prestador 	= nr_seq_prest_partic_w)
				) alias11;

				if (qt_partic_duplic_w > 1) then
					ie_partic_valido_w	:= 'S';
				end if;
			else
				ie_partic_valido_w	:= 'S';
			end if;
		end if;

		if (ie_partic_valido_w = 'S') then
			insert into w_pls_ocorrencia_partic(nr_sequencia, dt_atualizacao, nm_usuario,
				 dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_participante,
				 nr_seq_ocorrencia)
			values (nextval('w_pls_ocorrencia_partic_seq'), clock_timestamp(), nm_usuario_p,
				 clock_timestamp(), nm_usuario_p, nr_seq_partic_w,
				 nr_seq_ocorrencia_p);
		end if;
		end;
	end loop;
	close C03;

	end;
end loop;
close C04;

<<final2>>

/*Fechar o cursor se este estiver aberto*/

null;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_se_regra_particip ( nr_seq_conta_proc_p bigint, nr_seq_regra_partic_p bigint, nm_usuario_p text, ie_retorno_p INOUT text, nr_seq_ocorrencia_p bigint) FROM PUBLIC;

